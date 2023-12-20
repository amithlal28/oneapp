import 'dart:async';
import 'dart:developer';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:one_app/backend/data.dart';
import 'package:one_app/backend/database.dart';
import 'package:one_app/screens/addFeatures.dart';
import 'package:one_app/screens/customizeSpecial.dart';
import 'package:one_app/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/auth.dart';
import '../sizes.dart';

class AppMain extends StatefulWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool private = false;
  String? icon = "", category;
  late Future<List> getAppFeatures;
  DatabaseMethods databaseMethods = DatabaseMethods();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getAppFeatures = Future.wait([
      databaseMethods.getAppFeatures(),
      Future.delayed(const Duration(seconds: 2), () {})
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
      body: Container(
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: screenHeight(context, mulBy: 0.03)),
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: screenHeight(context, mulBy: 0.35),
                  width: screenWidth(context, mulBy: 0.55),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: const [BoxShadow()],
                      color: Colors.white),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Hero(
                        tag: dataChild.appid,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: screenWidth(context, mulBy: 0.35),
                            height: screenHeight(context, mulBy: 0.2),
                            child: Image.network(
                              dataChild.icon!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  color: Colors.redAccent,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Text(
                        dataChild.name!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            FutureBuilder(
              future: getAppFeatures,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                    stream: databaseMethods.getAppDetailStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot1) {
                      if (snapshot1.hasData) {
                        if (dataChild.owner == "SuperSpecial") {
                          if (snapshot1.data["usedFeatures"]
                              .containsKey(user!.uid)) {
                            dataChild.usedFeatures![user!.uid] =
                                snapshot1.data["usedFeatures"][user!.uid];
                          }
                        }

                        return Column(
                          children: [
                            if (dataChild.owner == "SuperSpecial")
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CustomizeSpecial(
                                                snapshot: snapshot,
                                              )))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 40,
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade400
                                            .withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Text(
                                      "Customize",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: screenHeight(context, mulBy: 0.02),
                            ),
                            getList(snapshot)
                          ],
                        );
                      }
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            minHeight: 20,
                            color: Colors.green,
                            backgroundColor:
                                Colors.lightGreenAccent.withOpacity(0.2),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child:ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 30,
        width: double.infinity,
        child: LiquidLinearProgressIndicator(
          value: 0.5,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 15, 219, 66)),
          borderColor: Colors.transparent,
          borderWidth: 0.0,
          borderRadius: 10,
          direction: Axis.horizontal,
          center: Text(
            'Loading..',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
      Text(
        'Please wait while we are loading your Mini-App',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ],
  ),
),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              heroTag: null,
              backgroundColor: const Color(0xffa5b6ff),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.black,
                size: 27,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Description(),
                  ),
                );
              },
              heroTag: null,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.description_outlined,
                color: Colors.white.withOpacity(0.7),
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getList(dynamic snapshot) {


    if (dataChild.owner == "SuperSpecial") {
      if (dataChild.usedFeatures!.containsKey(user!.uid)) {
        log("Hey"+dataChild.owner!);

        log(dataChild.usedFeatures!.toString());

        if(dataChild.usedFeatures![user!.uid].length==0) {
          return SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  RichText(
                    text: TextSpan(
                      text: "No Features added.\n",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text:
                          "Try adding features from customize.",
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
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data![0].docs.length,
          itemBuilder: (context, index) {
            if ((dataChild.usedFeatures![user!.uid])
                .contains(snapshot.data![0].docs[index].id)) {
              return Features(
                featureInfo: snapshot.data![0].docs[index],
                selected: 0 == index,
              );
            } else {
              log(snapshot.data![0].docs[index].id);
              for (var element
                  in (dataChild.usedFeatures![user!.uid] as List)) {
                log(element);
              }
              log("${((dataChild.usedFeatures![user!.uid]).contains(snapshot.data![0].docs[index].id))}");

              return SizedBox();
            }
          },
        );
      }
      else{
        return SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                RichText(
                  text: TextSpan(
                    text: "No Features added.\n",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text:
                        "Try adding features from customize.",
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
          ),
        );
      }
    }
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: snapshot.data![0].docs.length,
      itemBuilder: (context, index) {
        return Features(
          featureInfo: snapshot.data![0].docs[index],
          selected: 0 == index,
        );
      },
    );
  }
}

class Features extends StatefulWidget {
  const Features({Key? key, required this.featureInfo, required this.selected})
      : super(key: key);

  final DocumentSnapshot featureInfo;
  final bool selected;
  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  final InAppBrowser browser = InAppBrowser();

  Future<void> onTap() async {
    if (await canLaunchUrl(
      Uri.parse(widget.featureInfo["link"]),
    )) {
      switch (widget.featureInfo["behaviour"]) {
        case "Deep Link":
          launchUrl(Uri.parse(widget.featureInfo["link"]),
              mode: LaunchMode.externalNonBrowserApplication);

          break;
        case "In-App":
          browser.openUrlRequest(
              urlRequest:
                  URLRequest(url: Uri.parse(widget.featureInfo["link"])),
              options: InAppBrowserClassOptions(
                  android: AndroidInAppBrowserOptions(
                    hideTitleBar: false,
                    allowGoBackWithBackButton: true,
                  ),
                  inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                    thirdPartyCookiesEnabled: true,
                  ))));
          break;
        case "External Browser":
          launchUrl(Uri.parse(widget.featureInfo["link"]),
              mode: LaunchMode.externalApplication);
          break;
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Can't open the link. Link broken.",
        style: TextStyle(color: Colors.white),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ExpansionTile(
        title: Text(
          widget.featureInfo["name"],
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 23),
        ),
        tilePadding: const EdgeInsets.only(
          left: 20,
        ),
        childrenPadding: EdgeInsets.symmetric(
            horizontal: screenWidth(context, mulBy: 0.07),
            vertical: screenHeight(context, mulBy: 0.02)),
        expandedAlignment: Alignment.centerLeft,
        leading: SizedBox(
          height: 40,
          child: widget.featureInfo["icon"] == "SuperSpecial"
              ? FutureBuilder(
                  future: FaviconFinder.getBest(widget.featureInfo["link"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(
                        snapshot.data!.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 30,
                          );
                        },
                      );
                    }
                    return CircularProgressIndicator();
                  })
              : Image.network(
                  widget.featureInfo["icon"],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 30,
                    );
                  },
                ),
        ),
        trailing: ElevatedButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              elevation: MaterialStateProperty.all(0),
            ),
            child: const Text(
              "Open",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
        subtitle: Text(
          widget.featureInfo["behaviour"],
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
        children: [
          Text(
            widget.featureInfo["desc"],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
          )
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

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
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: screenHeight(context, mulBy: 0.6),
            width: screenWidth(context, mulBy: 0.85),
            decoration: BoxDecoration(
              color: Color(0xff3d3d3d),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 5,
                    offset: Offset(0, 5)),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "${dataChild.name} Description\n",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    dataChild.desc!,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
