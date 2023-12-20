import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_app/backend/data.dart';
import 'package:one_app/screens/addToHome.dart';
import 'package:one_app/screens/appMainScreen.dart';
import 'package:one_app/screens/createApp.dart';
import '../backend/database.dart';
import '../home.dart';
import '../sizes.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/logo.png"
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                colors: [
                  Color(0xff6E8DE9),
                  Color(0xff464AD9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
            )
        ),
        height: 60,
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20
          ),
        ),
      ),
    );
  }
}

class MyButtonOutline extends StatelessWidget {
  const MyButtonOutline({Key? key, required this.child, required this.onTap}) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          border: Border.all(
            color: const Color(0xff464AD9),
            width: 2
          )
        ),
        height: 60,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}



class MyIcon extends StatelessWidget {
  MyIcon({Key? key, required this.appInfo, this.edit=false, this.store=false}) : super(key: key);

  DatabaseMethods databaseMethods = DatabaseMethods();

  final DocumentSnapshot appInfo;
  final bool edit, store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        dataChild.icon= appInfo["icon"];
        dataChild.name= appInfo["name"];
        dataChild.category= appInfo["category"];
        dataChild.desc= appInfo["desc"];
        dataChild.owner= appInfo["owner"];
        dataChild.private= appInfo["private"];
        dataChild.appid= appInfo.id;

        if(appInfo["owner"]=="SuperSpecial"){
          dataChild.usedFeatures= appInfo["usedFeatures"];
        }

        if(store){
          Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const AddToHome(),));
        }
        else{
          Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const AppMain(),));
        }


      },
      onLongPress: edit?(){
        showModalBottomSheet(context: context,
          builder: (context) {
          return Container(
            height: 150,

           decoration: const BoxDecoration(
             color: Color(0xff2a2a2a),
           ),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight(context, mulBy: 0.02),
                ),

                SizedBox(
                  height: screenHeight(context, mulBy: 0.01),
                ),
                ListTile(
                  title: Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18),),
                  leading: Icon(Icons.edit, color: Colors.white,),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 25
                  ),
                  onTap: (){
                    dataChild.icon= appInfo["icon"];
                    dataChild.name= appInfo["name"];
                    dataChild.category= appInfo["category"];
                    dataChild.desc= appInfo["desc"];
                    dataChild.owner= appInfo["owner"];
                    dataChild.private= appInfo["private"];
                    dataChild.appid= appInfo.id;

                    Navigator.of(context,).push(MaterialPageRoute(builder: (context) => const CreateApp(
                      edit: true,
                    ),));
                  },
                ),
                ListTile(
                  title: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 18),),
                  leading: Icon(Icons.delete, color: Colors.white,),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 25
                  ),
                  onTap: (){
                    showAlertDialog1(
                      context: context,
                      title: "Delete",
                      content: "Are you sure to delete app?",
                      noButton: () {
                        Navigator.of(context).pop();
                      },
                      yesButton: () {

                        Navigator.of(context).pop();
                        showLoaderDialog(context);
                        databaseMethods.deleteApp(appInfo.id).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("App Deleted."))
                          );
                          Navigator.of(context,).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home(),), (Route<dynamic> route) => false);
                        });

                      },
                    );


                  },
                ),
              ],
            ),
          );
        },);
      }:null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [const BoxShadow()],
              color: Colors.white
            ),
            clipBehavior: Clip.antiAlias,

            margin: const EdgeInsets.only(
              bottom: 5
            ),
            child: Hero(
              tag: appInfo.id,
              child: Image.network(
                appInfo["icon"],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.redAccent, size: 30,);
                },

              ),
            ),
          ),

          SizedBox(
            width: 65,
            child: Text(
                appInfo["name"],
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14
              ),
            ),
          )
        ],
      ),
    );
  }
}


class MyHomeButton extends StatelessWidget {
  const MyHomeButton({Key? key, required this.child, required this.onTap}) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 1, 3, 8),
                    Color.fromARGB(255, 11, 118, 212),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight
              ),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset(0, 5)
              ),
            ]
          ),
          height: screenHeight(context, mulBy: 0.17),
          width: screenWidth(context, mulBy: 0.6),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}



showAlertDialog2(Dialog alert, BuildContext context) {
  showDialog(
    context: context,

    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog1({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback noButton,
  required VoidCallback yesButton,
}) {
  Widget cancelButton = TextButton(
    onPressed: noButton,
    child: Text(
      "No",
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
  );

  Widget approveButton = TextButton(
    onPressed: yesButton,
    child: Text(
      "Yes",
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    ),
    content: Text(
      content,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
    actions: [
      approveButton,
      cancelButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,

        ),
      );
    },
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isURl(){
    return  Uri.tryParse(this+"/")?.hasAbsolutePath?? false;  }
}

extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return trim()
          .split(' ')
          .map((element) =>
              "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
          .toList()
          .join(' ');
    } else {
      return "";
    }
  }

  String getInitials() =>
      isNotEmpty ? trim().split(' ').map((l) => l[0]).take(2).join() : '';
}

String subtextMaker(
  List subs,
) {
  String subText = "";
  for (var element in subs) {
    subText += "${element.split("(")[1].split(")")[0]},  ";
  }
  return subText;
}

String namer(String name1) {
  String name2 = name1;
  switch (name1) {
    case "prev qp":
      name2 = "Previous Question Papers";
      break;
    case "hNotes":
      name2 = "Hand Written Notes";
      break;
    case "ppt":
      name2 = "PowerPoint Slides";
      break;
    case "dNotes":
      name2 = "Digital Notes";
      break;
  }
  return name2;
}

class NumberButton extends StatelessWidget {
  NumberButton(
      {Key? key, required this.text, required this.number, required this.onTap})
      : super(key: key);

  String text;
  String number;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffffca5d),
            borderRadius: BorderRadius.circular(25)),
        height: screenWidth(context, mulBy: 0.37),
        width: screenWidth(context, mulBy: 0.4),
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: screenHeight(context, mulBy: 0.025)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: const TextStyle(
                  color: Color(0xff9188e5),
                  fontWeight: FontWeight.bold,
                  fontSize: 80),
            ),
            Text(
              text,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: const TextStyle(
                  color: Color(0xff1f1f24),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NameButton extends StatelessWidget {
  NameButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  String text;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffffca5d),
            borderRadius: BorderRadius.circular(25)),
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth(context, mulBy: 0.04)),
        height: screenHeight(context, mulBy: 0.1),
        width: screenWidth(context, mulBy: 0.7),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff1f1f24),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        )),
      ),
    );
  }
}

class ImgButton extends StatelessWidget {
  ImgButton(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.imgUrl,
      required this.subText,
      this.initialText,
      this.initial = false})
      : super(key: key);

  String text;
  VoidCallback onTap;
  String imgUrl;
  String? subText, initialText;
  bool initial;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      highlightColor: Colors.transparent,
      enableFeedback: true,
      splashColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: const Color(0xff3d386d),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(0, 3),
                  blurRadius: 4)
            ]),
        margin: EdgeInsets.only(
          top: screenHeight(context, mulBy: 0.025),
          right: screenWidth(context, mulBy: 0.025),
          left: screenWidth(context, mulBy: 0.025),
        ),
        height: screenHeight(context, mulBy: 0.17),
        width: screenWidth(
          context,
        ),
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.centerLeft,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: imgUrl.contains("http")
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, obj, trace) => Container(
                        height: screenHeight(context, mulBy: 0.18),
                        width: screenWidth(context, mulBy: 0.25),
                        padding: EdgeInsets.only(
                          right: screenWidth(context, mulBy: 0.03),
                          left: screenWidth(context, mulBy: 0.07),
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          text.getInitials(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            fontSize: 45,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      height: screenHeight(context, mulBy: 0.18),
                      width: screenWidth(context, mulBy: 0.25),
                    )
                  : Image.asset(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, obj, trace) => Container(
                        height: screenHeight(context, mulBy: 0.18),
                        width: screenWidth(context, mulBy: 0.25),
                        padding: EdgeInsets.only(
                          right: screenWidth(context, mulBy: 0.03),
                          left: screenWidth(context, mulBy: 0.07),
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          text.getInitials(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            fontSize: 45,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      height: screenHeight(context, mulBy: 0.18),
                      width: screenWidth(context, mulBy: 0.25),
                    ),
            ),
            if (initial && (initialText == null))
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: screenHeight(context, mulBy: 0.18),
                  width: screenWidth(context, mulBy: 0.25),
                  padding:
                      EdgeInsets.only(right: screenWidth(context, mulBy: 0.03)),
                  alignment: Alignment.centerRight,
                  child: Text(
                    text.getInitials(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      fontSize: 45,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                  ),
                ),
              ),
            if (initial && (initialText != null))
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: screenHeight(context, mulBy: 0.18),
                  width: screenWidth(context, mulBy: 0.25),
                  padding:
                      EdgeInsets.only(right: screenWidth(context, mulBy: 0.03)),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${initialText!.substring(0, 3)}\n${initialText!.substring(3, 6)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      overflow: TextOverflow.clip,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            Container(
              width: screenWidth(context, mulBy: 0.85),
              height: screenHeight(context),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      stops: [0.83, 0.94],
                      colors: [Color(0xffffca5d), Colors.transparent])),
              padding: EdgeInsets.only(
                  left: screenWidth(context, mulBy: 0.03),
                  right: screenWidth(context, mulBy: 0.07),
                  top: screenHeight(context, mulBy: 0.02),
                  bottom: screenHeight(context, mulBy: 0.02)),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xff1f1f24),
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                  Text(
                    subText!,
                    style: const TextStyle(
                      color: Color(0xff1f1f24),
                      fontWeight: FontWeight.w400,
                      fontSize: 13.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  ProfileButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  String text;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffffca5d),
            borderRadius: BorderRadius.circular(25)),
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth(context, mulBy: 0.04)),
        margin: EdgeInsets.only(bottom: screenHeight(context, mulBy: 0.015)),
        height: screenHeight(context, mulBy: 0.1),
        width: screenWidth(context, mulBy: 0.7),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xff1f1f24),
            fontWeight: FontWeight.bold,
            fontSize: 16 * screenHeight(context, mulBy: 0.0018),
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}

class ClickButton extends StatefulWidget {
  ClickButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.loading = false,
      this.height = 0.09})
      : super(key: key);

  String text;
  VoidCallback onTap;
  bool loading;
  double height;

  @override
  State<ClickButton> createState() => _ClickButtonState();
}

class _ClickButtonState extends State<ClickButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: widget.loading ? null : widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffffca5d),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffffffff).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context, mulBy: 0.04)),
          height: screenHeight(context, mulBy: widget.height),
          width: screenWidth(context, mulBy: 0.8),
          child: widget.loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Color(0xff1f1f24),
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(
                      width: screenWidth(context, mulBy: 0.05),
                    ),
                    const CupertinoActivityIndicator(
                      color: Color(0xff1f1f24),
                      radius: 11,
                    )
                  ],
                )
              : Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Color(0xff1f1f24),
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
        ),
      ),
    );
  }
}

class StarkText extends StatelessWidget {
  StarkText(this.text,
      {Key? key,
      this.style,
      this.maxLines = 1,
      this.textAlign = TextAlign.left})
      : super(key: key);
  String text = "";
  TextStyle? style;
  int maxLines;
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          (text == "") ? " " : text,
          style: style,
          maxLines: maxLines,
        ));
  }
}

class ZMTextField extends StatelessWidget {
  ZMTextField(
      {Key? key,
      required this.controller,
      this.onChanged,
      this.keyboardType,
      this.maxLength,
      this.suffixIcon,
      required this.hint,
      this.label,
      this.obscure = false,
      this.radius = 40,
      this.inputFormatters = const [],
      this.textInputAction})
      : super(key: key);
  TextEditingController controller;
  Function(String)? onChanged;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  int? maxLength;
  String? hint, label;
  Widget? suffixIcon;
  bool obscure;
  double radius;
  List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: 1,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      obscureText: obscure,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: "",
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffca5d), width: 2.0),
            borderRadius: BorderRadius.circular(radius)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(radius)),
        fillColor: const Color(0xff16161c),
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        suffixIcon: suffixIcon,
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Color(0xffffca5d)),
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth(context, mulBy: 0.06),
            vertical: screenHeight(context, mulBy: 0.03)),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  ProfileTextField(
      {Key? key,
      required this.controller,
      this.keyboardType,
      this.hintText,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  TextEditingController controller;
  TextInputType? keyboardType;
  TextCapitalization textCapitalization;
  String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context, mulBy: 0.08),
      width: screenWidth(context),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          bottom: screenHeight(context, mulBy: 0.02),
          top: screenHeight(context, mulBy: 0.01)),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: const TextStyle(
            color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w300),
        textAlign: TextAlign.start,
        autofocus: false,
        enabled: true,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          counterText: "",
          fillColor: Colors.white.withOpacity(0.1),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xffffca5d), width: 2.0),
              borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth(context, mulBy: 0.03)),
        ),
      ),
    );
  }
}


