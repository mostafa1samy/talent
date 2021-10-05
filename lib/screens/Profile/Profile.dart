import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Laoding/LoadingPage.dart';
import 'package:fcitalent/screens/Profile/Profilehlpers.dart';
import 'package:fcitalent/screens/edit_profile.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: Icon(EvaIcons.settings2Outline,color: constantColors.lightBlueColor,),),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(EvaIcons.logOutOutline,color: constantColors.greenColor,) ,onPressed:(){
            Provider.of<ProfileHelper>(context,listen: false).logOtDialog(context);
          }),
          IconButton(icon: Icon(EvaIcons.editOutline,color: constantColors.greenColor,) ,onPressed:(){
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return EditProfile();
           }));
          })
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(text: TextSpan(text: 'My',style: TextStyle(color:constantColors.whiteColor,fontSize: 20.0 ),children: <TextSpan>[
          TextSpan(text: 'Profile',style: TextStyle(color: constantColors.blueColor,fontSize: 20.0,fontWeight: FontWeight.bold))
        ]),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .doc(Provider.of<Authentication>(context,listen: false).getUserUid).snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{
                  return new Column(
                    children: [

                     Provider.of<ProfileHelper>(context,listen: false).headerProfile(context,snapshot.data),
                      Provider.of<ProfileHelper>(context,listen: false).divider(),
                      Provider.of<ProfileHelper>(context,listen: false).middleProfile(context, snapshot),
                      Provider.of<ProfileHelper>(context,listen: false).footerProfile(context, snapshot),

                    ],
                  );
                }
              },
            )
            ,
            decoration: BoxDecoration(color: constantColors.blueGreyColor.withOpacity(0.6),borderRadius: BorderRadius.circular(15.0)),
        ),),
      ),
    );
  }
}
