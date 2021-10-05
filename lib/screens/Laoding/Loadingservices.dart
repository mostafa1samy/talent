import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/screens/Laoding/Loadingutils.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoadingServices with ChangeNotifier {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController usernme = new TextEditingController();
  TextEditingController talent = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController emaill = new TextEditingController();
  TextEditingController passwordl = new TextEditingController();
  ConstantColors constantColors = new ConstantColors();
  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                      Provider.of<LoadingUtils>(context, listen: false)
                          .userAvatar),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<LoadingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
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
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .uploadUserAvarar(context)
                              .whenComplete(() {
                            signinSheet(context);
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
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(15.0)),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentsnapshot) {
              return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: constantColors.darkColor,
                    backgroundImage:
                        //NetworkImage('https://firebasestorage.googleapis.com/v0/b/fciapp-f6d4f.appspot.com/o/userProfileAvatar%2Fdata%2Fuser%2F0%2Fcom.example.fcitalent%2Fcache%2Fimage_picker7192713139767832717.jpg%2FTimeOfDay(23%3A56)?alt=media&token=173f6a7d-719e-4eb1-98bf-e2eeb4c7f775')
                        NetworkImage(documentsnapshot.data()['userimage']),
                  ),
                  title: Text(
                    documentsnapshot.data()['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor),
                  ),
                  subtitle: Text(
                    documentsnapshot.data()['useremail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor),
                  ),
                  trailing: Expanded(
                    child: Container(
                      width: 120.0,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.check,
                                color: constantColors.blueColor),
                            onPressed: () {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .loginToAcconut(
                                      documentsnapshot.data()['useremail'],
                                      documentsnapshot.data()['userpassword'])
                                  .whenComplete(() {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Home(),
                                        type: PageTransitionType.leftToRight));
                              });
                            },
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.trashAlt,
                                  color: constantColors.redColor),
                              onPressed: () {
                                Provider.of<FirebaseOperation>(context,
                                        listen: false)
                                    .deleteUserData(
                                        documentsnapshot.data()['useruid'],
                                        'users');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }).toList());
          }
        },
      ),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emaill,
                      decoration: InputDecoration(
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordl,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (emaill.text.isNotEmpty && passwordl.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .loginToAcconut(
                                  emaill.text, passwordl.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: Home(),
                                    type: PageTransitionType.bottomToTop));
                          });
                          ;
                        } else if (passwordl.text.length < 7) {
                          waringText(context, "password short!");
                        } else if (!emaill.text.contains('@')) {
                          waringText(context, "email invaild!");
                        } else {
                          waringText(context, "fill all the data!");
                        }
                      },
                      backgroundColor: constantColors.blueColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  signinSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0))),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LoadingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.transperant,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      decoration: InputDecoration(
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: usernme,
                      decoration: InputDecoration(
                          hintText: 'Enter UserName',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: talent,
                      decoration: InputDecoration(
                          hintText: 'Enter Talent',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: phone,
                      decoration: InputDecoration(
                          hintText: 'Enter Phone',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (email.text.isNotEmpty &&
                            password.text.isNotEmpty &&
                            usernme.text.isNotEmpty &&
                            phone.text.isNotEmpty &&
                            talent.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAcconut(
                                  email.text, password.text)
                              .whenComplete(() {
                            print("createing c");
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .createUserCollectin(context, {
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'useremail': email.text,
                              'userpassword': password.text,
                              'username': usernme.text,
                              'talent': talent.text,
                              'phone': phone.text,
                              'userimage': Provider.of<LoadingUtils>(context,
                                      listen: false)
                                  .getuserAvatarUrl
                            });
                          }).whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: Home(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else if (password.text.length < 7) {
                          waringText(context, "password short!");
                        } else if (!email.text.contains('@')) {
                          waringText(context, "email invaild!");
                        } else {
                          waringText(context, "fill all the data!");
                        }
                      },
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  waringText(BuildContext context, String waring) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                waring,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        });
  }
}
