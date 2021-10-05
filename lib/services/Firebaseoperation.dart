import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/screens/Laoding/Loadingutils.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseOperation with ChangeNotifier {
  UploadTask imageUploadTask;
  String intiUserEmail,
      intiUserImage,
      intiUserName,
      intiUserTalent,

      initiUserPhone;
  String get getUserEmail => intiUserEmail;
  String get getUserImage => intiUserImage;
  String get getUserName => intiUserName;
  String get getUserTalent => intiUserTalent;
  String get getUserPhone => initiUserPhone;
  Future uploadUserAvarar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LoadingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LoadingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('uploadimage');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LoadingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'the user profile avatar=>${Provider.of<LoadingUtils>(context, listen: false).userAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUserCollectin(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future intiUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print("fetch user data");
      intiUserEmail = doc.data()['useremail'];
      intiUserName = doc.data()['username'];
      intiUserImage = doc.data()['userimage'];
      intiUserTalent = doc.data()['talent'];
      initiUserPhone = doc.data()['phone'];
      print(intiUserEmail);
      notifyListeners();
    });
  }

  Future uoloadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future addReward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future updataPost(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future folowuser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitchatroomdata(String chatroomname, dynamic chatroomdata) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomname)
        .set(chatroomdata);
  }
}
