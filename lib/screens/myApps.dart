


import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/backend/data.dart';
import 'package:one_app/backend/database.dart';
import 'package:one_app/screens/addFeatures.dart';
import 'package:one_app/widgets/widgets.dart';

import '../backend/auth.dart';
import '../sizes.dart';

class MyApps extends StatefulWidget {
  const MyApps({Key? key}) : super(key: key);

  @override
  State<MyApps> createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {

  late Future getMyApps;
  DatabaseMethods databaseMethods= DatabaseMethods();

  @override
  void initState() {
    getMyApps= databaseMethods.getMyApps();
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
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        actions: [
          Container(
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
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: screenHeight(context, mulBy: 0.03),
            left: screenWidth(context, mulBy: 0.08),
            right: screenWidth(context, mulBy: 0.08)
        ),
        children: [
          const Text(
            "My Apps",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.05),
          ),
          Expanded(
              child: FutureBuilder(
                future: getMyApps,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: snapshot.data.docs.map<Widget>((e) => MyIcon(
                          appInfo: e,
                        edit: true,
                      )).toList(),
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
}

class AddIcon extends StatefulWidget {
  const AddIcon({
    super.key,
    required this.iconController,
  });

  final TextEditingController iconController;

  @override
  State<AddIcon> createState() => _AddIconState();
}

class _AddIconState extends State<AddIcon> {
  late TextEditingController newController;

  @override
  void initState() {
    newController = TextEditingController(text: widget.iconController.text);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 20,
          bottom: 10
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Icon",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(0, 5)
                    ),
                  ],

                  borderRadius: BorderRadius.circular(20)
              ),
              child: TextField(
                controller: newController,
                textInputAction: TextInputAction.done,
                onSubmitted: (s){
                  setState(() {

                  });
                },
                onChanged: (s){
                  setState(() {

                  });
                },
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: const Color(0xff3d3d3d),
                  filled: true,
                  hintText: "Icon Link",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  floatingLabelStyle: const TextStyle(color: Color(0xffffca5d)),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context, mulBy: 0.03),
                      vertical: screenHeight(context, mulBy: 0.03)),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow()],
                  color: Colors.white
              ),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(
                  bottom: 5
              ),
              child: Image.network(
                newController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.redAccent, size: 30,);
                },

              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.015),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: (){
                      newController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      widget.iconController.text=newController.text;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Select",
                      style: TextStyle(color: Theme.of(context).primaryColor),
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
