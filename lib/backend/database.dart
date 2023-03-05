import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_app/screens/addFeatures.dart';

import 'auth.dart';
import 'branchProvider.dart';
import 'data.dart';

class DatabaseMethods {
  Future<void> addUsernfo(personData) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(personData["uid"])
        .set(personData)
        .catchError((e) {
      log(e.toString());
    });
  } //used

   addApp(data) async {
    return FirebaseFirestore.instance
        .collection("Apps")
        .add(data)
        .catchError((e) {});
  } //used

  editApp(data) async {
    return FirebaseFirestore.instance
        .collection("Apps")
        .doc(dataChild.appid)
    .update(data)
        .catchError((e) {});
  } //used

  Future<void> addAppFeatures(List data) async {
    for (var element in data) {
      FirebaseFirestore.instance
          .collection("Apps")
      .doc(dataChild.appid)
      .collection("Features")
          .add(element)
          .catchError((e) {
            log(e.toString());
      });
    }
  } //used

  Future<void> updateAppFeatures({required List<FeatureData> featureData, required List<String> deleted}) async {

    for (var e in deleted) {
      FirebaseFirestore.instance
          .collection("Apps")
          .doc(dataChild.appid)
          .collection("Features")
          .doc(e)
      .delete()
          .catchError((e) {
        log(e.toString());
      });
    }

    for (var e in featureData) {

      Map<String, dynamic> map= {
        "name":e.nameController!.text,
        "icon": e.icon,
        "behaviour": e.behaviour,
        "link": e.linkController!.text,
        "desc": e.descController!.text
      };
      if(e.id==null){

        FirebaseFirestore.instance
            .collection("Apps")
            .doc(dataChild.appid)
            .collection("Features")
            .add(map)
            .catchError((e) {
          log(e.toString());
        });
      }else{
        FirebaseFirestore.instance
            .collection("Apps")
            .doc(dataChild.appid)
            .collection("Features")
            .doc(e.id)
            .update(map)
            .catchError((e) {
          log(e.toString());
        });
      }


    }


  } //used

  getApps() async {

    return FirebaseFirestore.instance
        .collection("Apps")
    .where("private", isEqualTo: false)
        .get()
        .catchError((e) {});
  } //used

  getMyApps() async {
    return FirebaseFirestore.instance
        .collection("Apps")
    .where("owner", isEqualTo: user!.uid)
        .get()
        .catchError((e) {});
  } //used

  getAppFeatures() async {

    log(dataChild.appid);
      return FirebaseFirestore.instance
          .collection("Apps")
          .doc(dataChild.appid)
          .collection("Features")
          .get()
          .catchError((e) {
            log(e.toString());
      });
  } //used


  Future<void> updateUserInfo(personData) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid)
        .update(personData)
        .catchError((e) {
      log(e.message);
    });
  } //used

  Future getPersonInfo() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get();
  } //used





}
