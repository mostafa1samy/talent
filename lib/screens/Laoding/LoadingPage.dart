import 'package:flutter/material.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Laoding/LoadingHlper.dart';
import 'package:provider/provider.dart';

class Laodingpage extends StatelessWidget {
  final ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodeColor(),
          Provider.of<LoadingHlpers>(context,listen: false).bodyImage(context),
          Provider.of<LoadingHlpers>(context,listen: false).tagLineText(context),
          Provider.of<LoadingHlpers>(context,listen: false).mainButtton(context),
          Provider.of<LoadingHlpers>(context,listen: false).privcytext(context),

        ],
      ),
    );
  }
  bodeColor(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
        stops: [0.5,0.9],
        colors: [constantColors.darkColor,constantColors.blueColor])
      ),
    );
  }
}
