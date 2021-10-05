import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeHlper with ChangeNotifier{
  ConstantColors constantColors = new ConstantColors();
  Widget bottomNavBar(BuildContext context,int index,PageController pageController){
    return CustomNavigationBar(items:[
      CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
      CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
      CustomNavigationBarItem(icon: Icon(EvaIcons.search)),


      CustomNavigationBarItem(icon:Provider.of<FirebaseOperation>(context,listen: false).getUserImage!=null?
        CircleAvatar(radius: 35.0,backgroundColor: constantColors.blueGreyColor,
          backgroundImage:
          NetworkImage(Provider.of<FirebaseOperation>(context,listen: false).getUserImage)


      ):CircleAvatar(radius: 35.0,backgroundColor: constantColors.blueGreyColor,)),
    ],
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val){
      index=val;
      pageController.jumpToPage(val);
      notifyListeners();
      },
      backgroundColor: Color(0xff040307)

      ,currentIndex: index,bubbleCurve: Curves.bounceIn,scaleCurve: Curves.decelerate,);
  }
}