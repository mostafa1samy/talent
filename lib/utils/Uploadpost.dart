import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController captionTextEditController = TextEditingController();
  TextEditingController locextEditController = TextEditingController();
  File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  UploadTask imageUploadTask;
  final picker = ImagePicker();
  Future pickPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageValr = await picker.getImage(source: source);
    uploadPostImageValr == null
        ? print("Select Image")
        : uploadPostImage = File(uploadPostImageValr.path);
    print(uploadPostImageValr.path);
    uploadPostImage != null
        ? showPostImage(context)
        : print('image upload erro');
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
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
                      onPressed: () {
                        pickPostImage(context, ImageSource.gallery);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallary',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        pickPostImage(context, ImageSource.camera);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('Posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(uploadPostImage);
    await imageUploadTask.whenComplete(() {
      print('imge post uploaded');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl.toString();
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 200.0,
                    width: 400.0,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          selectPostImageType(context);
                        },
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: constantColors.whiteColor),
                        ),
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        onPressed: () {
                          uploadPostImageToFirebase().whenComplete(() {
                            editPostSheet(context);
                            print('image uploded');
                          });
                        },
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.image_aspect_ratio,
                                  color: constantColors.greenColor,
                                ),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(
                                  Icons.fit_screen,
                                  color: constantColors.yellowColor,
                                ),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: 300.0,
                        child: Image.file(
                          uploadPostImage,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.blueColor,
                      ),
                      Container(
                        height: 120.0,
                        width: 330.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLength: 100,
                            controller: captionTextEditController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: 'Add A Caption....',
                                hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.orange,
                    size: 35.0,
                  ),
                  title: TextField(
                    controller: locextEditController,
                    decoration: InputDecoration(
                        hintText: "Where was this taken ",
                        border: InputBorder.none),
                  ),
                ),
                Container(

                  padding: EdgeInsets.all(6.0),
                  child: RaisedButton.icon(
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      getUserLocation();
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Use Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .uoloadPostData(captionTextEditController.text.trim(), {
                      'caption': captionTextEditController.text.trim(),
                      'userimage':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserImage,
                      'username':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserName,
                      'useremail':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserEmail,
                      'usertalent':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserTalent,
                      'phone':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getUserPhone,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'postimage': getUploadPostImageUrl,
                      'loca': locextEditController.text
                    }).whenComplete(() async {
                      return FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'caption': captionTextEditController.text.trim(),
                        'userimage': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserImage,
                        'username': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserName,
                        'useremail': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserEmail,
                        'usertalent': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserTalent,
                        'phone': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getUserPhone,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'postimage': getUploadPostImageUrl,
                        'loca': locextEditController.text
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  color: constantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        });
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String fullAddress =
        "${placemark.locality} " + "," + "${placemark.country} ";
    print("full address is $placemark");
    locextEditController.text = fullAddress;
  }
}
