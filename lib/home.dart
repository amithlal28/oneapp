

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_app/screens/createApp.dart';
import 'package:one_app/screens/myApps.dart';
import 'package:one_app/screens/welcome.dart';
import 'package:one_app/sizes.dart';
import 'package:one_app/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  late Future getApps;
  DatabaseMethods databaseMethods= DatabaseMethods();

  @override
  void initState() {
    getApps= databaseMethods.getApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCFF1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xffCFF1F1),
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
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff251B5C),
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
          left: screenWidth(context, mulBy: 0.08),
        right: screenWidth(context, mulBy: 0.08)
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
            Color(0xff6857D7),
            Color(0xff4934B7),
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
                color: const Color(0xff483C97)
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: FutureBuilder(
                future: getApps,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: snapshot.data.docs.map<Widget>((e) => MyIcon(
                        appInfo: e
                      )).toList(),
                    );
                  }
                  return CircularProgressIndicator(
                    color: Colors.white,
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
          "Hai!\n${user!.displayName!.split(" ")[0]}",
          style: const TextStyle(
            color: Color(0xff6857D7),
            fontSize: 30,
            fontWeight: FontWeight.bold
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
            onTap: (){}
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
            onTap: (){
              Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const MyApps(),));
            }
        ),
      ],
    );
  }

}

