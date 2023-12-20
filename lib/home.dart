

import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_app/screens/contact.dart';
import 'package:one_app/screens/createApp.dart';
import 'package:one_app/screens/help.dart';
import 'package:one_app/screens/myApps.dart';
import 'package:one_app/screens/store.dart';
import 'package:one_app/screens/welcome.dart';
import 'package:one_app/sizes.dart';
import 'package:one_app/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';

import 'backend/auth.dart';
import 'backend/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final PanelController pc = PanelController();
  AuthMethods authMethods = AuthMethods();
  late Future<List> getApps;
  DatabaseMethods databaseMethods= DatabaseMethods();

  @override
  void initState() {
    getApps= Future.wait([
      databaseMethods.getPersonInfo().then((value) => currApps=value["apps"]),
      databaseMethods.getPublicApps(),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a2a2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a2a2a),
        elevation: 0,

        actions: [
          InkWell(
            onTap: () {
              showAlertDialog1(
                context: context,
                title: "Sign Out",
                content: "Are you sure to sign out?",
                noButton: () {
                  Navigator.of(context).pop();
                },
                yesButton: () {
                  Navigator.of(context).pop();
                  showLoaderDialog(context);
                  authMethods.signOut().then((value) {
                    user=null;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                            const Welcome()),
                            (Route<dynamic> route) => false);
                  });
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: 40,
              width: 40,
              margin: const EdgeInsets.symmetric(
                horizontal: 10
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                user!.photoURL!
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Image.asset(
                  "assets/images/logo.png"
                )
            ),
            const Divider(
              color: Colors.black,
              height: 2,
            ),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context)=>Help())
                );
              },
            ),
            ListTile(
              title: Text(
                "Contact Us",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context)=>Contact())
                );
              },
            ),
            ListTile(
              title: Text(
                "Sign Out",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              onTap: (){
                showAlertDialog1(
                  context: context,
                  title: "Sign Out",
                  content: "Are you sure to sign out?",
                  noButton: () {
                    Navigator.of(context).pop();
                  },
                  yesButton: () {
                    Navigator.of(context).pop();
                    showLoaderDialog(context);
                    authMethods.signOut().then((value) {
                      user=null;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                              const Welcome()),
                              (Route<dynamic> route) => false);
                    });
                  },
                );
              },
            ),
            Spacer(),
            ListTile(
              title: Center(
                child: Text(
                  "App Version: 1.0.5",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
        backgroundColor: const Color(0xff1a1818),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateApp(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 26,
        ),
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        minHeight: 100,
        maxHeight: screenHeight(context, mulBy: 0.63),
        controller: pc,
        panel: panel(),
        body: body(),
      ),
    );
  }

  Widget panel(){
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(
          top: screenHeight(context, mulBy: 0.03),
          left: screenWidth(context, mulBy: 0.055),
        right: screenWidth(context, mulBy: 0.055)
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3b3b3b),
            Color(0xff2d2d2d),
          ]
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 10,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff2d2d2d),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: FutureBuilder<List>(
                future: Future.wait([
                  databaseMethods.getPersonInfo().then((value) => currApps=value["apps"]),
                  databaseMethods.getAllApps(),
                ]),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 20,
                      spacing: 20,
                      children: (snapshot.data![1].docs.where((e) => (currApps.contains(e.id)||(e["owner"]==user!.uid )))).map<Widget>((e) {
                        return MyIcon(
                            appInfo: e
                        );
                      }).toList(),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              )
          ),
        ],
      ),
    );
  }


  Widget body(){
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      children: [
        SizedBox(
          height: screenHeight(context, mulBy: 0.05),
        ),
        Text(
          "Welcome \n${user!.displayName!.split(" ")[0]} !",
          style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 40,
          ),
        ),
        SizedBox(
          height: screenHeight(context, mulBy: 0.05),
        ),
        MyHomeButton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shopping_cart_checkout,
                  color: Colors.white,
                  size: 35,
                ),
                const Text(
                  "One Store",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                )
              ],
            ),
            onTap: () async {
              await Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const Store(),)).then((value) => setState((){}));
            }
        ),
        SizedBox(
          height: screenHeight(context, mulBy: 0.05),
        ),
        MyHomeButton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                  size: 35,
                ),
                const Text(
                  "My Apps",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                )
              ],
            ),
            onTap: () async {
              await Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const MyApps(),)).then((value) => setState((){}));
            }
        ),
      ],
    );
  }

}


