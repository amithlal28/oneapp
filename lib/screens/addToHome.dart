import 'package:flutter/material.dart';
import 'package:one_app/widgets/widgets.dart';

import '../backend/auth.dart';
import '../backend/data.dart';
import '../backend/database.dart';
import '../sizes.dart';

class AddToHome extends StatefulWidget {
  const AddToHome({Key? key}) : super(key: key);

  @override
  State<AddToHome> createState() => _AddToHomeState();
}

class _AddToHomeState extends State<AddToHome> {
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
      Future.delayed(const Duration(seconds: 3), () {})
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
              child: Row(
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
                            return const Icon(Icons.error, color: Colors.redAccent, size: 30,);
                          },

                        ),
                      ),
                    ),
                  ),
                  Text(
                    dataChild.name!,
                    style: const TextStyle(
                      color: Colors.white,
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
          (dataChild.owner==user!.uid)?
          InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                "You can't remove your app from OneApp"
              )));
            },
            child: Container(
              height: screenHeight(context, mulBy: 0.08),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "This app belongs to you",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ):
          ((currApps.contains(dataChild.appid))?
            InkWell(
              onTap: (){

                showLoaderDialog(context);
                databaseMethods.deleteOneApp(dataChild.appid).then((value) {
                  Navigator.pop(context);
                  setState(() {

                  });
                });

              },
              child: Container(
                height: screenHeight(context, mulBy: 0.08),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                    "Remove from OneApp",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ):
            InkWell(
              onTap: (){
                showLoaderDialog(context);
                databaseMethods.addOneApp(dataChild.appid).then((value) {
Navigator.pop(context);
                  setState(() {

                  });
                });

              },
              child: Container(
                height: screenHeight(context, mulBy: 0.08),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "Add to OneApp",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )),
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
            Container(
              height: screenHeight(context, mulBy: 0.3),
              width: screenWidth(context, mulBy: 0.85),
              decoration: BoxDecoration(
                color: Color(0xff3d3d3d),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(0, 5)
                  ),],
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20
              ),
              child: Column(
                children: [
                  Text(
                    "App Description\n",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,

                        color: Colors.white
                    ),
                  ),
                  Text(
                    dataChild.desc!,

                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,

                        color: Colors.white
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
