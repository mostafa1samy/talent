import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Laoding/LoadingPage.dart';
import 'package:page_transition/page_transition.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  ConstantColors constantColors = new ConstantColors();
  @override
  void initState() {
    Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context,PageTransition(child: Laodingpage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'the',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
              children: <TextSpan>[TextSpan(text: 'Talent',style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.blueColor,
                  fontSize: 30.0))]),
        ),
      ),
    );
  }
}
