


import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/backend/data.dart';
import 'package:one_app/backend/database.dart';
import 'package:one_app/screens/addFeatures.dart';
import 'package:one_app/widgets/widgets.dart';

import '../backend/auth.dart';
import '../sizes.dart';

class CreateApp extends StatefulWidget {
  const CreateApp({Key? key}) : super(key: key);

  @override
  State<CreateApp> createState() => _CreateAppState();
}

class _CreateAppState extends State<CreateApp> {

  TextEditingController nameController= TextEditingController();
  TextEditingController iconController= TextEditingController();
  TextEditingController descController= TextEditingController();
  bool private= false;
  String? category;

  DatabaseMethods databaseMethods= DatabaseMethods();

@override
  void initState() {
    iconController.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6958D8),
      appBar: AppBar(
        backgroundColor: const Color(0xff6958D8),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            colors: [
              Color(0xff6958D8),
              Color(0xff4530B3)
            ]
          )
        ),

        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
            vertical: screenHeight(context, mulBy: 0.03)
          ),
          children: [
            const Text(
              "Create\nYour App",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    Dialog dialog= Dialog(
                      backgroundColor: const Color(0xff2a2a2a),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: AddIcon(iconController: iconController),
                    );
                    showAlertDialog2(dialog, context);
                  },
                  child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: Offset(0, 5)
                            ),],
                          border: Border.all(
                            color: Colors.white
                          ),
                          color: const Color(0xff796AD7)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: iconController.text==""?const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ):Image.network(
                        iconController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.redAccent, size: 30,);
                        },

                      )),
                ),
                Container(
                    height: 60,
                    width: 200,
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
                      controller: nameController,
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xff796AD7),
                        filled: true,
                        hintText: "App Name",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        suffixIcon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
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
              ],
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
            Container(
              width: 300,
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
                controller: descController,
                maxLines: 6,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(20)),
                  fillColor: const Color(0xff796AD7),
                  filled: true,
                  hintText: "App Description",
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
              height: 60,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(0, 5)
                    ),],
                  border: Border.all(
                      color: Colors.white
                  ),
                  color: const Color(0xff796AD7)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                items: <String>['Education', 'Health', 'Store'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16),),
                  );
                }).toList(),
                hint: const Text("Select Category", style: TextStyle(color: Colors.white, fontSize: 16),),
                iconEnabledColor: Colors.white,
                underline: const SizedBox(),
                isExpanded: true,
                value: category,
                dropdownColor: const Color(0xff8478D2),
                borderRadius: BorderRadius.circular(10),
                onChanged: (a) {
                  setState(() {
                    category=a!;
                  });
                },
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Public  ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                CupertinoSwitch(
                    value: private,
                    onChanged: (a){
                      setState(() {
                        private=a;
                      });
                    },
                  activeColor: Colors.blue,
                  trackColor: Colors.white.withOpacity(0.8),
                ),
                const Text(
                  "  Private",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            InkWell(
              onTap: (){
                if(
                    nameController.text!=""&&
                    descController.text!=""&&
                //icon!=""&&
                category!=null
                ){
                  showLoaderDialog(context);

                  Map<String, dynamic> data={
                    "name":nameController.text,
                    "icon": iconController.text,
                    "category":category!,
                    "desc": descController.text,
                    "owner": user!.uid,
                    "private": private
                  };


                  databaseMethods.addApp(data).then((value) {
                    dataChild.appid=value.id;
                    dataChild.icon= data["icon"];
                    dataChild.name= data["name"];
                    dataChild.category= data["category"];
                    dataChild.desc= data["desc"];
                    dataChild.owner= data["owner"];
                    dataChild.private= data["private"];
                    Navigator.of(context).pop();

                    Navigator.of(context,).pushReplacement(MaterialPageRoute(builder: (context) => const AddFeatures(),));

                  });
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
                      "Fill all the contents"
                  )));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border.all(
                        color: const Color(0xff6958D8),
                        width: 2
                    )
                ),
                height: 60,
                alignment: Alignment.center,
                child: const Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff464AD9),
                      fontSize: 20
                  ),
                ),
              ),
            )
          ],
        ),
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
