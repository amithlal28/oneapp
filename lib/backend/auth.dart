// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/toast.dart';

User? user;
List currApps=[];

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  int? forceResendingToken;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      user = null;
    });
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      log(e.toString());
    }
  }


  Future<UserCredential?> signInWithGoogle({BuildContext? context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCredential;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          userCredential = await auth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            showToast(text: "Email already used", icon: CupertinoIcons.xmark);
          } else if (e.code == 'invalid-credential') {
            showToast(text: "Invalid Credentials", icon: CupertinoIcons.xmark);
          }
        } catch (e) {
          showToast(text: "Error occured", icon: CupertinoIcons.xmark);
        }
      }
    }
    return userCredential;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password, VoidCallback loadStop) async {
    User? firebaseUser;

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;
      loadStop();
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(text: "User not found", icon: CupertinoIcons.xmark);
        loadStop();
      } else if (e.code == 'wrong-password') {
        showToast(text: "Wrong password", icon: CupertinoIcons.xmark);
        loadStop();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<User?> reAuthenticate(VoidCallback loadStop) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          user = await _auth.currentUser!
              .reauthenticateWithCredential(credential)
              .then((value) {
            loadStop();
            return value.user;
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            showToast(text: "Email already used", icon: CupertinoIcons.xmark);
          } else if (e.code == 'invalid-credential') {
            showToast(text: "Invalid Credentials", icon: CupertinoIcons.xmark);
          }
        } catch (e) {
          showToast(text: "Error occured", icon: CupertinoIcons.xmark);
        }
      }
    }
    return user;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, VoidCallback loadStop) async {
    User? firebaseUser;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;
      loadStop;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(text: "Weak password", icon: CupertinoIcons.xmark);
        loadStop();
      } else if (e.code == 'email-already-in-use') {
        showToast(text: "Email already in use", icon: CupertinoIcons.xmark);
        loadStop();
      }
    } catch (e) {
      print(e);
    }
    return firebaseUser;
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
