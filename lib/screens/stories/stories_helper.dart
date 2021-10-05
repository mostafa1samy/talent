import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/screens/stories/stories_widget.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart'as timeago;

class StoriesHelper with ChangeNotifier{
  final StoryWidget storyWidget=StoryWidget();
final picker=ImagePicker();
UploadTask imageUploadTask;
String storyImageUrl,storyHightlightIcon,storyTime,lastseentime;
String get getStoryImageUrl =>storyImageUrl;
  String get getStoryHightlightIcon =>storyHightlightIcon;
  String get getstoryTime=>storyTime;
  String get getlastseentime=>lastseentime;
File storyImage;
File get getStoryImage =>storyImage;
Future slectStoryImage (BuildContext context,ImageSource source) async{
  final pickedStoryImage= await picker.getImage(source: source);
  pickedStoryImage==null?print("Erro"):storyImage=File(pickedStoryImage.path);
  storyImage!=null?storyWidget.previewStoryImage(context, storyImage) :print('Erro');
  notifyListeners();
}

Future uploadStoryImage(BuildContext context) async{
  Reference imageReference= FirebaseStorage.instance.ref().child('Stories/${getStoryImage.path}/${Timestamp.now()}');
  imageUploadTask=imageReference.putFile(getStoryImage);
  await imageUploadTask.whenComplete(() {
    print('story image uploaded');
  });
  imageReference.getDownloadURL().then((url) {
    storyImageUrl=url;
    print(storyImageUrl);
  });
  notifyListeners();
}

Future convertHightlightIcon(String firestoreImageUrl)async{
  storyHightlightIcon=firestoreImageUrl;
  print(firestoreImageUrl);
  notifyListeners();
}
Future addStoryToNewAlbum(BuildContext context,String userUid,String highLightName,String StoryName)async{
  return FirebaseFirestore.instance.collection('users').doc(userUid).
  collection('hightlights').doc(highLightName).set({
    'title':highLightName,
    'cover':storyHightlightIcon
  }).whenComplete(() {
    return FirebaseFirestore.instance.collection('users').doc(userUid).collection('hightlights').doc(highLightName).collection('stories').
    add({
      'image':getStoryImageUrl,
      'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
      'userimage':Provider.of<FirebaseOperation>(context,listen: false).getUserImage,
      // 'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
      'time':Timestamp.now(),
      //'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
    });
  });



}
storyTimepost(dynamic timeData){
  Timestamp timestamp=timeData;
  DateTime dateTime=timestamp.toDate();
  storyTime=timeago.format(dateTime);
  lastseentime=timeago.format(dateTime);
  notifyListeners();
}
Future addSeenStemp(BuildContext context,String storyId,String personId,DocumentSnapshot documentSnapshot)async{
  if(documentSnapshot.data()['useruid']!=Provider.of<Authentication>(context,listen: false).getUserUid){
    return FirebaseFirestore.instance.collection('stories').doc(storyId)
        .collection('seen').doc(personId).set({

      'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
      'userimage':Provider.of<FirebaseOperation>(context,listen: false).getUserImage,
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'time':Timestamp.now(),
    });
  }
}

}