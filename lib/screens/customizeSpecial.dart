import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:one_app/backend/data.dart';
import 'package:one_app/backend/database.dart';
import 'package:one_app/screens/addFeatures.dart';
import 'package:one_app/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/auth.dart';
import '../sizes.dart';

class CustomizeSpecial extends StatefulWidget {
  const CustomizeSpecial({Key? key, required this.snapshot}) : super(key: key);

  final dynamic snapshot;

  @override
  State<CustomizeSpecial> createState() => _CustomizeSpecialState();
}

class _CustomizeSpecialState extends State<CustomizeSpecial> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool private = false;
  String? icon = "", category;
  late Future<List> getAppFeatures;
  DatabaseMethods databaseMethods = DatabaseMethods();
  ScrollController scrollController = ScrollController();
  List selected=[];


  @override
  void initState() {
    getAppFeatures = Future.wait([
      databaseMethods.getAppFeatures(),
      Future.delayed(const Duration(seconds: 3), () {})
    ]);
    if(dataChild.usedFeatures!.containsKey(user!.uid)){
      selected= dataChild.usedFeatures![user!.uid];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a2a2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a2a2a),
        elevation: 0,
        title: Text("Customize", ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            height: 40,
            width: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: Clip.antiAlias,
            child: Image.network(user!.photoURL!),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: screenHeight(context, mulBy: 0.03)),
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Select the features you like:",
                  style: TextStyle(
                  fontSize: 18,
                    color: Colors.white
                ),),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: widget.snapshot.data![0].docs.length,
                  itemBuilder: (context, index) {
                    return Features(
                      featureInfo: widget.snapshot.data![0].docs[index],
                      selected: selected.contains(widget.snapshot.data![0].docs[index].id),
                      onTap: (){
                        setState(() {
                          if(selected.contains(widget.snapshot.data![0].docs[index].id)){
                            selected.remove(widget.snapshot.data![0].docs[index].id);
                          }else{
                            selected.add(widget.snapshot.data![0].docs[index].id);
                          }
                        });

                      },
                    );
                  },
                )
              ],
            ),
          ),
          InkWell(
            onTap: (){
              showLoaderDialog(context);
              databaseMethods.editSpecialFeature(selected).then((value) {
                dataChild.usedFeatures![user!.uid]= selected;
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: Container(
              height: 50,
              width: screenWidth(context),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              alignment: Alignment.center,
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Features extends StatefulWidget {
  const Features({Key? key, required this.featureInfo, required this.selected, required this.onTap})
      : super(key: key);

  final DocumentSnapshot featureInfo;
  final bool selected;
  final VoidCallback onTap;
  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {

  final InAppBrowser browser = InAppBrowser();




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: widget.onTap,
        title: Text(
          widget.featureInfo["name"],
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 23),
        ),
        leading: SizedBox(
          height: 40,
          child: FutureBuilder(
              future: FaviconFinder.getBest(widget.featureInfo["link"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data!.url,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.redAccent,
                        size: 30,
                      );
                    },

                  );
                }
                return CircularProgressIndicator();
              }),
        ),
        trailing: Icon(
          widget.selected?Icons.check_box_outlined:Icons.check_box_outline_blank,
          color: Colors.white,
          size: 30,
        ),
        subtitle: Text(
          widget.featureInfo["behaviour"],
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ),
    );
  }
}

