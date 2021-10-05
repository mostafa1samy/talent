import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/screens/Laoding/Loadingutils.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'Loadingservices.dart';

class LoadingHlpers with ChangeNotifier{
  ConstantColors constantColors = new ConstantColors();
  Widget bodyImage(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height* 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login.png'))
      ),
    );
  }
  Widget tagLineText(BuildContext context){

    return Positioned(child: Container(
      constraints: BoxConstraints(maxWidth: 170.0),child: RichText(
      text: TextSpan(
          text: 'Are ',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 40.0),
          children: <TextSpan>[TextSpan(text: 'You ',style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.whiteColor,
              fontSize: 40.0)),
            TextSpan(text: 'Talented',style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.blueColor,
                fontSize: 35.0)),
            TextSpan(text: '? ',style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 40.0))]),
    ),),
      top: 450.0,left:10.0,);
  }
  Widget  mainButtton(BuildContext context){
    return Positioned(top: 630.0,child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
        GestureDetector(
          onTap: (){
            emailAuthSheet(context);
          },
          child: Container(
            child: Icon(EvaIcons.emailOutline,color: constantColors.yellowColor,),
            width: 80.0,
              height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: constantColors.yellowColor
              ),borderRadius: BorderRadius.circular(10.0)
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            print("sign in google");
            Provider.of<Authentication>(context,listen: false).signinWithGoogle().whenComplete(() {
              Navigator.pushReplacement(context,PageTransition(child: Home(), type: PageTransitionType.leftToRight));
            });
          },
          child: Container(
            child: Icon(FontAwesomeIcons.google,color: constantColors.redColor,),
            width: 80.0,
            height: 40.0,
            decoration: BoxDecoration(
                border: Border.all(
                    color: constantColors.redColor
                ),borderRadius: BorderRadius.circular(10.0)
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            child: Icon(FontAwesomeIcons.facebookF,color: constantColors.blueColor,),
            width: 80.0,
            height: 40.0,
            decoration: BoxDecoration(
                border: Border.all(
                    color: constantColors.blueColor
                ),borderRadius: BorderRadius.circular(10.0)
            ),
          ),
        )
      ],),
    ),);
  }
  Widget privcytext(BuildContext context){
    return Positioned(child: Column(children: [
      Text("By continuing you agree the talent's Terms of",style: TextStyle(color: Colors.grey.shade600,fontSize: 12.0),),
      Text("services & privacy policy",style: TextStyle(color: Colors.grey.shade600,fontSize: 12.0),)
    ],),top: 720,left: 20.0,right: 20.0,);
  }
  emailAuthSheet(BuildContext context){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150.0),
          child: Divider(
            thickness: 4.0,
            color: constantColors.whiteColor,
          ),
        ),
        Provider.of<LoadingServices>(context,listen: false).passwordLessSignIn(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              color: constantColors.blueColor,
              onPressed: (){
                Provider.of<LoadingServices>(context,listen: false).logInSheet(context);

            },
      child:Text("Log in",style: TextStyle(color: constantColors.whiteColor,fontSize: 18.0,fontWeight: FontWeight.bold)) ,),
            MaterialButton(
              color: constantColors.redColor,
              onPressed: (){
                Provider.of<LoadingUtils>(context,listen: false).selectAvatarOptionsSheet(context);

            },
              child:Text("Sign up",style: TextStyle(color: constantColors.whiteColor,fontSize: 18.0,fontWeight: FontWeight.bold)) ,),

          ],
        )
      ],
      ),height: MediaQuery.of(context).size.height* 0.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: constantColors.blueGreyColor,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0))),);
    });
  }

}
