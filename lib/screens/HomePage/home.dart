import 'dart:io';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Chatroom/Chatroom.dart';
import 'package:fcitalent/screens/Feed/Feed.dart';
import 'package:fcitalent/screens/HomePage/Homepagehelper.dart';
import 'package:fcitalent/screens/Profile/Profile.dart';
import 'package:fcitalent/screens/Search.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ConstantColors constantColors = new ConstantColors();
  final PageController homepagecontroller=PageController();
  int pageIndex=0;
  @override
  void initState() {
    Provider.of<FirebaseOperation>(context,listen: false).intiUserData(context);
    super.initState();

  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: new Text(
          "Exit Application",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: new Text("Are You Sure?"),
        actions: <Widget>[
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              exit(0);
            },
          ),
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              "No",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homepagecontroller,
          children: [Feed(),ChatRoom(),Search(),Profile(),],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page){
            setState(() {
              pageIndex=page;
            });
          },
        ),
       bottomNavigationBar: Provider.of<HomeHlper>(context,listen: false).bottomNavBar(context,pageIndex, homepagecontroller)
      ),
    );
  }
}
