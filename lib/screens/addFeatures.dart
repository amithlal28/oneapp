


import 'dart:developer';

import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_app/home.dart';
import 'package:one_app/widgets/widgets.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../backend/auth.dart';
import '../backend/data.dart';
import '../backend/database.dart';
import '../sizes.dart';
import '../widgets/toast.dart';

class AddFeatures extends StatefulWidget {
  const AddFeatures({Key? key, this.edit=false}) : super(key: key);

  final bool edit;
  @override
  State<AddFeatures> createState() => _AddFeaturesState();
}

class _AddFeaturesState extends State<AddFeatures> {

  ValueNotifier<int> selectedIndex= ValueNotifier(0);
  PageController pageController = PageController(
    viewportFraction: 0.9,
    initialPage: 0,
  );
  DatabaseMethods databaseMethods= DatabaseMethods();
  late Future getAppFeatures;

  List<FeatureData> featureData=[];

  @override
  void initState() {
    fToast.init(context);
    if(widget.edit){
      getAppFeatures = databaseMethods.getAppFeatures();
    }else{
      featureData.add(FeatureData());
    }

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
            showAlertDialog1(
              context: context,
              title: "Go back?",
              content: "Your app '${dataChild.name}' is already created. You haven't added any features. Are you sure to go to home screen?",
              noButton: () {
                Navigator.of(context).pop();
              },
              yesButton: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
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

        child: widget.edit? edit():ListView(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight(context, mulBy: 0.03)
          ),
          children:
          [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Add Your\nFeatures",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),

            SizedBox(
              height: screenHeight(context, mulBy: 0.67),
              child: PageView.builder(
                  controller: pageController,

                  itemBuilder: (BuildContext context, int index) {
                    return Feature(
                        featureData: featureData[index],
                      count: featureData.length,
                      onClose: (){
setState(() {
  featureData.removeAt(index);

});                      },
                    );
                  },
                onPageChanged: (int page) {
                  selectedIndex.value = page;
                },
                itemCount: featureData.length,
              ),
            ),
        CirclePageIndicator(
          itemCount: featureData.length,
          currentPageNotifier: selectedIndex,
        ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  if(
                  featureData.last.behaviour!=null&&
                      featureData.last.icon!=null&&
                      featureData.last.linkController!.text!=""&&
                      featureData.last.linkController!.text.isURl()&&
                      featureData.last.nameController!.text!=""
                  ){
                    setState(() {
                      featureData.add(FeatureData());
                      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
                      color: const Color(0xff6353C0),
                  ),
                  height: 60,
                  width: screenWidth(context, mulBy: 0.6),
                  alignment: Alignment.center,
                  child: const Text(
                    "Add new Feature",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.03),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: InkWell(
                onTap: (){
                  if(
                  featureData.last.behaviour!=null&&
                      featureData.last.icon!=null&&
                      featureData.last.linkController!.text!=""&&
                      featureData.last.linkController!.text.isURl()&&
                      featureData.last.nameController!.text!=""
                  ){
                    showLoaderDialog(context);

                    List<Map<String, dynamic>> dataList= featureData.map((e) => {
                      "name":e.nameController!.text,
                      "icon": e.icon,
                      "behaviour": e.behaviour,
                      "link": e.linkController!.text,
                      "desc": e.descController!.text
                    }).toList();


                    databaseMethods.addAppFeatures(dataList).then((value) {
                      Navigator.pop(context);
                      showToast(text: "App created", icon: Icons.check);
                     Navigator.of(context,).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home(),), (Route<dynamic> route) => false);
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
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff464AD9),
                        fontSize: 20
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget edit(){
    return FutureBuilder(
      future: getAppFeatures,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          return ListView(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight(context, mulBy: 0.03)
            ),
            children:
            [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Edit Your\nFeatures",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context, mulBy: 0.03),
              ),

              SizedBox(
                height: screenHeight(context, mulBy: 0.67),
                child: PageView.builder(
                  controller: pageController,

                  itemBuilder: (BuildContext context, int index) {
                    return Feature(
                      featureData: [...snapshot.data.docs.map((e) => FeatureData(
                        icon: e["icon"],
                        behaviour: e["behaviour"],
                        descController: TextEditingController(text: e["desc"]),
                        linkController: TextEditingController(text: e["link"]),
                        nameController: TextEditingController(text: e["name"])
                      )),...featureData,][index],
                      count: featureData.length,
                      onClose: (){
                        setState(() {
                          featureData.removeAt(index);

                        });                      },
                    );
                  },
                  onPageChanged: (int page) {
                    selectedIndex.value = page;
                  },
                  itemCount: [...snapshot.data.docs,...featureData,].length,
                ),
              ),
              CirclePageIndicator(
                itemCount: [...snapshot.data.docs,...featureData,].length,
                currentPageNotifier: selectedIndex,
              ),
              SizedBox(
                height: screenHeight(context, mulBy: 0.03),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    if(
                    featureData.last.behaviour!=null&&
                        featureData.last.icon!=null&&
                        featureData.last.linkController!.text!=""&&
                        featureData.last.linkController!.text.isURl()&&
                        featureData.last.nameController!.text!=""
                    ){
                      setState(() {
                        featureData.add(FeatureData());
                        pageController.animateToPage([...snapshot.data.docs,...featureData,].length-1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
                      color: const Color(0xff6353C0),
                    ),
                    height: 60,
                    width: screenWidth(context, mulBy: 0.6),
                    alignment: Alignment.center,
                    child: const Text(
                      "Add new Feature",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context, mulBy: 0.03),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: InkWell(
                  onTap: (){
                    if(
                    featureData.last.behaviour!=null&&
                        featureData.last.icon!=null&&
                        featureData.last.linkController!.text!=""&&
                        featureData.last.linkController!.text.isURl()&&
                        featureData.last.nameController!.text!=""
                    ){
                      showLoaderDialog(context);

                      List<Map<String, dynamic>> dataList= featureData.map((e) => {
                        "name":e.nameController!.text,
                        "icon": e.icon,
                        "behaviour": e.behaviour,
                        "link": e.linkController!.text,
                        "desc": e.descController!.text
                      }).toList();


                      databaseMethods.addAppFeatures(dataList).then((value) {
                        Navigator.pop(context);
                        showToast(text: "App created", icon: Icons.check);
                        Navigator.of(context,).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home(),), (Route<dynamic> route) => false);
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
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff464AD9),
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

}


class FeatureData{

  String? icon, behaviour;
  TextEditingController? nameController= TextEditingController();
  TextEditingController? linkController= TextEditingController();
  TextEditingController? descController= TextEditingController();

  FeatureData(
      {
        //TODO
    this.icon="",
    this.behaviour,
        this.nameController,
        this.descController,
        this.linkController
  }
  );
}

class Feature extends StatefulWidget {
  const Feature({Key? key, required this.featureData, required this.onClose, required this.count}) : super(key: key);

  final VoidCallback onClose;
  final FeatureData featureData;
  final int count;

  @override
  State<Feature> createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        Container(
          height: screenHeight(context, mulBy: 0.64),
          decoration: BoxDecoration(
            color: const Color(0xff796AD6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: Offset(0, 5)
              ),],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20
          ),
          margin: const EdgeInsets.only(
            bottom: 10,
            left: 10
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Add the feature link. Icon is auto added."))
                      );
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
                            color: Colors.white
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: EdgeInsets.all(10),
                        child: widget.featureData.linkController!.text==""?const Icon(
                          Icons.image,
                          color: Color(0xff2a2a2a),
                          size: 35,
                        ):Image.network(
                          widget.featureData.icon!,
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
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 5,
                              offset: Offset(0, 5)
                          ),
                        ],

                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      controller: widget.featureData.nameController,
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
                        hintText: "Feature Name",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
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
                height: screenHeight(context, mulBy: 0.03),
              ),
              Container(
                  height: 60,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
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
                    items: <String>['In-App', 'Deep Link', 'External Browser'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16),),
                      );
                    }).toList(),
                    hint: const Text("Feature Behaviour", style: TextStyle(color: Colors.white, fontSize: 16),),
                    iconEnabledColor: Colors.white,
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: widget.featureData.behaviour,
                    dropdownColor: const Color(0xff8478D2),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (a) {
                      setState(() {
                        widget.featureData.behaviour=a!;
                      });
                    },
                  ),
              ),
              SizedBox(
                height: screenHeight(context, mulBy: 0.03),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 5,
                          offset: Offset(0, 5)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextField(
                  controller: widget.featureData.linkController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  onTap: (){
                    if(widget.featureData.linkController!.text==""){
                      widget.featureData.linkController!.text="https://";
                    }
                  },
                  onChanged: (String s) async {
                    log(s);
                    log(s.isURl().toString());
                    if(s.isURl()) {
                      try{
                        await FaviconFinder.getBest(widget.featureData.linkController!.text).then((value) {
                          setState(() {
                            widget.featureData.icon = value!.url;
                          });
                        });
                      }
                      catch(e){

                      }
                    }
                  },
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
                    hintText: "Feature Link",
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
                width: 300,
                decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 5,
                          offset: Offset(0, 5)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextField(
                  controller: widget.featureData.descController,
                  maxLines: 4,
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

            ],
          ),
        ),
        if(widget.count!=1)
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              widget.onClose();
            },
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
              height: 30,
              width: 30,
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
