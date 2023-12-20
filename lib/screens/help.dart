

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../backend/auth.dart';
import '../backend/database.dart';
import '../sizes.dart';
import '../widgets/widgets.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> with TickerProviderStateMixin {


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
          "Help",
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
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome to One-App !',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'One-App is a powerful platform that brings together a collection of Mini-apps, offering a wide range of services and features to enhance your daily life. Whether you need to stay organized, access entertainment, connect with friends, manage your finances, or much more, One-App has got you covered.',
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 188, 176, 176)),
            ),
            SizedBox(height: 24),
            Text(
              'Here\'s a quick guide to help you navigate and make the most of your experience with One-App and its Mini-apps:',
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 188, 176, 176)),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home Screen',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Upon opening One-App, you\'ll be greeted with the Home Screen, where you\'ll find a curated selection of featured Mini-apps.',style: TextStyle(
                     color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mini-apps',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'One-App consists of various Mini-apps, each serving a specific purpose.',style: TextStyle(
                     color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mini-app Store',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The One-Store is your gateway to discovering and installing new Mini-apps.',style: TextStyle(
                     color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalization',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'One-App allows you to personalize your experience by organizing your favorite Mini-apps on the Home Screen.',style: TextStyle(
                    color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special-Apps',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Special-Apps are applications provided by the admin. These apps are predefined with a pool of features.',style: TextStyle(
                     color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account and Settings',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'One-App offers a user-friendly account and settings section for managing your preferences.',
                style: TextStyle(
                     color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help and Support',
                  style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'If you encounter any issues or have questions about One-App or a specific Mini-app, you can access the Help and Support section.',
                style: TextStyle(
                    color: Color.fromARGB(255, 188, 176, 176),
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
