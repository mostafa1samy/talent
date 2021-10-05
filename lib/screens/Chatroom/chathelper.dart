import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/alt.dart';
import 'package:fcitalent/screens/message/groupmessaging.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart'as timago;

class ChatHlper with ChangeNotifier  {
  String lastmessagetime;
  String get getlastmessagetime=>lastmessagetime;
  String chatroomavatarurl, chatroomid;
  String get getchatroomid => chatroomid;
  String get getchatroomavaterurl => chatroomavatarurl;
  ConstantColors constantColors = new ConstantColors();
  TextEditingController chatroomname = new TextEditingController();
  showchatroomdetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: .4,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: constantColors.blueColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Member',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    documentSnapshot.data()['useruid']) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: Alt(
                                              userUid: documentSnapshot
                                                  .data()['useruid']),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userimage']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  // color: constantColors.redColor,
                  height: MediaQuery.of(context).size.height * .08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: constantColors.blueColor)),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage:
                            NetworkImage(documentSnapshot.data()['userimage']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          documentSnapshot.data()['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                     Provider.of<Authentication>(context,listen: false).getUserUid==documentSnapshot.data()['useruid']?
                     Padding(
                       padding: const EdgeInsets.only(left: 10),
                       child: MaterialButton(
                         color: constantColors.redColor,
                         onPressed: () {

                           return showDialog(context: context,builder: (context){
                             return AlertDialog(
                               title:Text('Delete Room',
                                   style: TextStyle(
                                       color: constantColors.whiteColor,
                                       fontSize: 16.0,
                                       fontWeight: FontWeight.bold)),
                               backgroundColor: constantColors.darkColor,
                               actions: [
                                 MaterialButton(

                                   child: Text('No',
                                       style: TextStyle(

                                           color: constantColors.whiteColor,
                                           fontSize: 16.0,
                                           decoration: TextDecoration.underline,
                                           fontWeight: FontWeight.bold)),
                                   onPressed: (){Navigator.pop(context);},),
                                 MaterialButton(
                                   color:constantColors.redColor,

                                   child: Text('yes',
                                       style: TextStyle(
                                           color: constantColors.whiteColor,
                                           fontSize: 16.0,
                                           fontWeight: FontWeight.bold)),
                                   onPressed: (){
                                     FirebaseFirestore.instance.collection('chatrooms').doc(
                                         documentSnapshot.id
                                     ).delete().whenComplete(() {
                                       Navigator.pop(context);
                                     });
                                   },)
                               ],
                             );
                           });
                         },
                         child: Text('Delete Room',
                             style: TextStyle(
                                 color: constantColors.whiteColor,
                                 fontSize: 16.0,
                                 fontWeight: FontWeight.bold)),
                       ),
                     ):Container(width: 0.0,height: 0.0,)
                    ],
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showcreateclassroomchat(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: .4,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomicons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentsnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatroomavatarurl =
                                      documentsnapshot.data()['image'];
                                  print(documentsnapshot.data()['image']);
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: chatroomavatarurl ==
                                                    documentsnapshot
                                                        .data()['image']
                                                ? constantColors.blueColor
                                                : constantColors.transperant)),
                                    height: 10,
                                    width: 40,
                                    child: Image.network(
                                        documentsnapshot.data()['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300,
                        child: TextField(
                          controller: chatroomname,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom id',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .submitchatroomdata(chatroomname.text, {
                            'roomavatar': getchatroomavaterurl,
                            'time': Timestamp.now(),
                            'roomname': chatroomname.text,
                            'userimage': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .getUserImage,
                            'username': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .getUserName,
                            'useremail': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .getUserEmail,
                            'usertalent': Provider.of<FirebaseOperation>(
                                    context,
                                    listen: false)
                                .getUserTalent,
                            'phone': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .getUserPhone,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                          }).whenComplete(() {
                            print('done');
                            Navigator.pop(context);
                          });
                        },
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * .30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0))),
            ),
          );
        });
  }

  shochatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          return ListView(
            children:
                snapshot.data.docs.map((DocumentSnapshot documentsnapsho) {

              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: GroupingMessage(
                              documentSnapshot: documentsnapsho),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showchatroomdetails(context, documentsnapsho);
                },
                trailing: Container(
                  width: 80.0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentsnapsho.id)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.data==null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          showlastmessagetime(snapshot.data.docs.first.data()['time']);
                          return getlastmessagetime!=null? Text(getlastmessagetime, style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),):Container(
                            height: 0.0,width: 0.0,
                          );
                        }
                      }),
                ),
                title: Text(
                  documentsnapsho.data()['roomname'],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(documentsnapsho.id)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && snapshot.data ==null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data.docs.first.data()['username'] !=
                            null &&
                        snapshot.data.docs.first.data()['message'] != null) {
                      return Text(
                        '${snapshot.data.docs.first.data()['username']} : ${snapshot.data.docs.first.data()['message']}  ',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.data.docs.first.data()['username'] !=
                            null &&
                        snapshot.data.docs.first.data()['sticker'] != null) {
                      return Text(
                        '${snapshot.data.docs.first.data()['username']} : stickers ',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Container(
                        width: 0.0,
                        height: 0.0,
                      );
                    }
                  },
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage:
                      NetworkImage(documentsnapsho.data()['roomavatar']),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
  showlastmessagetime(dynamic timedata){
    Timestamp time=timedata;
    DateTime dateTime=time.toDate();
    lastmessagetime=timago.format(dateTime);
    notifyListeners();
  }
}
