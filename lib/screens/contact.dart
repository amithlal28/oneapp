

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/auth.dart';
import '../backend/database.dart';
import '../sizes.dart';
import '../widgets/widgets.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a2a2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a2a2a),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical:  screenHeight(context, mulBy: 0.03)),
        child: Column(
          children: [
            DrawerHeader(
                child: Image.asset(
                    "assets/images/logo.png",
                  color: Colors.white,
                )
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.04),
            ),
            ListTile(
              title: Text(
                "Call Us",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
              ),
              subtitle: Text(
                "Call us for urgent issues",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                ),
              ),
              leading: Icon(
                Icons.call,
                color: Colors.white,
                size: 35,
              ),
              onTap: () async {
                await launchUrl(Uri(scheme: "tel", path: "6282854104"));
              },
            ),
            ListTile(
              title: Text(
                "Email Us",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
              ),
              subtitle: Text(
                "Email us for suggestions",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                ),
              ),
              leading: Icon(
                Icons.email,
                color: Colors.white,
                size: 35,
              ),
              onTap: () async {
                await launchUrl(Uri(
                  scheme: 'mailto',
                  path: 'oneappsuperapp@gmail.com',
                ));
              },
            )
          ],
        ),
      ),

    );
  }
}
