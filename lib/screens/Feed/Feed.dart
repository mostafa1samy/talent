import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Feed/Feedhelpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  GlobalKey<ScaffoldState> globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = new ConstantColors();
    return Scaffold(

      backgroundColor: constantColors.blueGreyColor,
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 9.0,left: 9.0),
              child: Text('Categories', style: TextStyle(color: constantColors.whiteColor, fontSize: 24,fontWeight: FontWeight.bold)),
            ),

            Divider(color: Colors.grey.shade400),
            Container(
              padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Prapare Food",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.fitness_center,
                        color: constantColors.whiteColor,
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Reading",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        FontAwesomeIcons.bookReader,
                        color: constantColors.whiteColor,
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              ),
            ),
            //Divider(color: Colors.grey.shade400),
            Container(
              padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Arts",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.adb,
                        color: constantColors.whiteColor,
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              ),
            ),
            //Divider(color: Colors.grey.shade400),
            Container(
              padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Sports",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.sports,
                        color: constantColors.whiteColor,
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              ),
            ),
            //Divider(color: Colors.grey.shade400),
          ],
        ),
      ),
      appBar: Provider.of<FeedHelper>(context, listen: false).appBar(context),
      body: Provider.of<FeedHelper>(context, listen: false).feedBody(context),
    );
  }
}
