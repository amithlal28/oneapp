

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../backend/auth.dart';
import '../backend/database.dart';
import '../sizes.dart';
import '../widgets/widgets.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {

  TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  DatabaseMethods databaseMethods = DatabaseMethods();
  late Future myFuture;
  List<DocumentSnapshot> education = [];
  List<DocumentSnapshot> health = [];
  List<DocumentSnapshot> commerce = [];
  List<DocumentSnapshot> social = [];
  int tabs = 0;

  Future getApps() async {

    education.clear();
    health.clear();
    commerce.clear();
    social.clear();
    tabs = 0;
    await databaseMethods.getPublicApps().then(
        (item){


          item.docs.forEach((element) {
            log(element["category"]);
            if (element["category"]=="Commerce") {
              if (commerce.isEmpty) {
                tabs++;
              }
              commerce.add(element);
            }
            else if (element["category"]=="Education") {
              if (education.isEmpty) {
                tabs++;
              }
              education.add(element);
            } else if (element["category"]=="Health") {
              if (health.isEmpty) {
                tabs++;
              }
              health.add(element);
            }  else if (element["category"]=="Social") {
              if (social.isEmpty) {
                tabs++;
              }
              social.add(element);
            }
          });
        }
    );
    log(health.length.toString());
    _tabController = TabController(length: tabs, vsync: this);
    return tabs;
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {

      });
    });
    myFuture = getApps();
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
          "One-Store",
          style: TextStyle(
            color: Colors.white
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
        child: FutureBuilder(
            future: myFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                log(snapshot.data.toString());
                if (snapshot.data == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        RichText(
                          text: TextSpan(
                            text: "No data found.\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              if(searchController.text.isEmpty)
                              TextSpan(
                                text:
                                "Try again later.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: Offset(0, 5)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counterText: "",
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(40)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 0.1),
                              borderRadius: BorderRadius.circular(40)),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          fillColor: const Color(0xff4c4c4c),
                          filled: true,
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                          floatingLabelStyle: const TextStyle(color: Color(0xffffca5d)),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth(context, mulBy: 0.03),
                          ),
                        ),
                      ),
                    ),
                    TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelColor:
                        Colors.white.withOpacity(0.3),
                        indicatorColor: Colors.green,
                        labelColor: Colors.green,
                        indicatorWeight: 4,
                        physics: const BouncingScrollPhysics(),
                        tabs: [
                          if (commerce.isNotEmpty)
                            const Tab(
                              text: "Commerce",
                            ),
                          if (education.isNotEmpty)
                            const Tab(
                              text: "Education",
                            ),
                          if (health.isNotEmpty)
                            const Tab(
                              text: "Health",
                            ),


                          if (social.isNotEmpty)
                            const Tab(
                              text: "Social",
                            ),
                        ]),
                    SizedBox(
                      height: screenHeight(context, mulBy: 0.03),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          if (commerce.isNotEmpty)
                            TabListView(
                              apps: commerce,
                              search: searchController.text,
                            ),
                          if (education.isNotEmpty)
                            TabListView(
                              apps: education,
                              search: searchController.text,
                            ),
                          if (health.isNotEmpty)
                            TabListView(
                              apps: health,
                              search: searchController.text,
                            ),
                          if (social.isNotEmpty)
                            TabListView(
                              apps: social,
                              search: searchController.text,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }),
      ),

    );
  }
}

class TabListView extends StatelessWidget {
  List<DocumentSnapshot> apps;
  String search;

  TabListView(
      {Key? key,
        required this.apps,
      required this.search});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      runSpacing: 20,
      spacing: 20,
      children: apps
          .where((item) => item["name"].toLowerCase().contains(search.toLowerCase()))
          .toList().map<Widget>((e) => MyIcon(
          appInfo: e,
        store: true,
      )).toList(),
    );
  }
}