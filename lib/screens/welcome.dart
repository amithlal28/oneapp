import 'package:flutter/material.dart';
import 'package:one_app/screens/googleAuth.dart';
import 'package:one_app/sizes.dart';
import 'package:one_app/widgets/widgets.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 35
          ),
          children: [
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.45),
              child: const Logo(),
            ),
            SizedBox(
              height: screenHeight(context, mulBy: 0.05),
            ),
            const Text("Welcome!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(
              height: screenHeight(context, mulBy: 0.02),
            ),
            const Text("Get started to the amazing experience of everything at OneApp.", style: TextStyle(fontSize: 18
              ,),),
            SizedBox(
              height: screenHeight(context, mulBy: 0.07),
            ),
            MyButton(text: "Get Started", onTap:(){
              Navigator.of(context,).push(MaterialPageRoute(builder: (context) => GoogleAuth(),));
            })
          ],
        ),
      ),
    );
  }
}
