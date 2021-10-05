



import 'dart:io';

import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Laoding/Loadingservices.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LoadingUtils with ChangeNotifier{
  ConstantColors constantColors = new ConstantColors();
  final picker =ImagePicker();
  File userAvatar;
  File get getUserAvatar =>userAvatar;
  String userAvatarUrl;
  String get getuserAvatarUrl =>userAvatarUrl;
  Future pickUserAvatar(BuildContext context,ImageSource source)async{
    final pickedUserAvatar=await picker.getImage(source: source);
   pickedUserAvatar==null? print("Select Image"):userAvatar=File(pickedUserAvatar.path);
   print(userAvatar.path);
   userAvatar !=null ? Provider.of<LoadingServices>(context,listen: false).showUserAvatar(context):print('image upload erro');
   notifyListeners();


  }
  Future selectAvatarOptionsSheet(BuildContext context)async{
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        child: Column(children: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0),
        child: Divider(
          thickness: 4.0,
          color: constantColors.whiteColor,
        ),
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            MaterialButton(
              color: constantColors.blueColor,
              onPressed: () {
                pickUserAvatar(context,ImageSource.gallery).whenComplete(() {
                  Navigator.pop(context);
                  Provider.of<LoadingServices>(context,listen: false).showUserAvatar(context);
                });
              },
              child: Text(
                "Gallary",
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                   fontSize: 18.0),
              ),
            ),
            MaterialButton(
              color: constantColors.blueColor,
              onPressed: () {
                pickUserAvatar(context,ImageSource.camera).whenComplete(() {
                  Navigator.pop(context);
                  Provider.of<LoadingServices>(context,listen: false).showUserAvatar(context);
                });
              },
              child: Text(
                "Camera",
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
          ],)
        ]),

        height: MediaQuery.of(context).size.height*.1,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: constantColors.blueGreyColor,
        borderRadius: BorderRadius.circular(15.0)
      ),);


    });
  }

}