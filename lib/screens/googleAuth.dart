import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../widgets/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../backend/auth.dart';
import '../../../backend/database.dart';
import '../../../home.dart';
import '../../../sizes.dart';
import '../widgets/toast.dart';

class GoogleAuth extends StatefulWidget {
  const GoogleAuth({Key? key}) : super(key: key);

  @override
  State<GoogleAuth> createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  bool _isSigningIn = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();
  late Map<String, dynamic> personDataMap;
  final PanelController pc = PanelController();



  @override
  void initState() {

    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isSigningIn
          ? bodyLoading():body(),
    );
  }

  Widget body() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 35,
          vertical: screenHeight(context, mulBy: 0.07)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight(context, mulBy: 0.05),
          ),
          StarkText(
            "Get Started",
            style: const TextStyle(
              color: Color(0xff464AD9),
              fontSize: 37,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.015),
          ),
          const Text(
            "Get Started with a OneApp account and you're good to go...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
          const Spacer(),
          SizedBox(
            height: screenHeight(context, mulBy: 0.3),
            child: Logo(),
          ),
          const Spacer(),
          MyButtonOutline(
            onTap: () async {
              setState(() {
                _isSigningIn = true;
              });

              user = await authMethods
                  .signInWithGoogle(context: context)
                  .then((value) {
                if(value!=null){
                  if (value.user != null) {
                    if (value.additionalUserInfo!.isNewUser) {
                      personDataMap = {
                        "uid": value.user!.uid,
                        "name": value.user!.displayName!.capitalize(),
                        "email": value.user!.email,
                        "phone": value.user!.phoneNumber ?? "",
                        "photoURL": value.user!.photoURL!.split("=")[0],
                        "verified": value.user!.emailVerified,
                      };
                      databaseMethods.addUsernfo(personDataMap);
                    }
                  }
                  return value.user;
                }
                else{
                  setState(() {
                    _isSigningIn = false;
                  });
                  return null;
                }
              });

              if(user!=null){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              }else{
                return;
              }

            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Image(
                  image: AssetImage("assets/images/google.png"),
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Continue with Google',
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.white38,
          ),
          const Text(
            "By registering, you confirm that you accept our Terms of Use and Privacy Policy",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 11,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.01),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: const Text(
                  "Terms of Use",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      decoration: TextDecoration.underline),
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget bodyLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 35,
          vertical: screenHeight(context, mulBy: 0.07)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight(context, mulBy: 0.02),
          ),
          StarkText(
            "Get Started",
            style: const TextStyle(
              color: Color(0xff464AD9),
              fontSize: 37,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.015),
          ),
          const Text(
            "Get Started with a OneApp account and you're good to go...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
          const Spacer(),
          SizedBox(
            height: screenHeight(context, mulBy: 0.3),
            child: Logo(),
          ),
          const Spacer(),
          SizedBox(
            height: 60,
            child: Center(
              child: const CupertinoActivityIndicator(
                color: Color(0xff464AD9),
                radius: 14,
              ),
            ),
          ),
          const Divider(
            color: Colors.white38,
          ),
          const Text(
            "By registering, you confirm that you accept our Terms of Use and Privacy Policy",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 11,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.01),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: const Text(
                  "Terms of Use",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      decoration: TextDecoration.underline),
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
