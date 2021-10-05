import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/alt.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeage;

class PostOption with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController comment = TextEditingController();
  TextEditingController updataCation = TextEditingController();
  String imagetimePostId;
  String get getimageTimePostId => imagetimePostId;
  showTimeGo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imagetimePostId = timeage.format(dateTime);
    print(imagetimePostId);
    notifyListeners();
  }

  showPostOption(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding:   EdgeInsets.only(  bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: " Add New Caption",
                                                  hintStyle: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12)),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              controller: updataCation,
                                            )),
                                        FloatingActionButton(
                                            backgroundColor:
                                                constantColors.redColor,
                                            child: Icon(
                                                FontAwesomeIcons.fileUpload,
                                                color: constantColors.whiteColor),
                                            onPressed: () {
                                              Provider.of<FirebaseOperation>(
                                                      context,
                                                      listen: false)
                                                  .updataPost(postId, {
                                                'caption': updataCation.text
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        color: constantColors.blueColor,
                        child: Text("Edit Post",
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constantColors.darkColor,
                                  title: Text("Delete This Post?",
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  constantColors.whiteColor,
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Provider.of<FirebaseOperation>(context,
                                                listen: false)
                                            .deleteUserData(postId,'posts')
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      color: constantColors.redColor,
                                      child: Text("Yes",
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ],
                                );
                              });
                        },
                        color: constantColors.redColor,
                        child: Text("Delete Post",
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )
                    ],
                  ))
                ],
              ),
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'useremail':
          Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
      'phone':
          Provider.of<FirebaseOperation>(context, listen: false).getUserPhone,
      'time': Timestamp.now(),
      'usertalent':
          Provider.of<FirebaseOperation>(context, listen: false).getUserTalent,
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
          ..set({
            'comment': comment,
            'username': Provider.of<FirebaseOperation>(context, listen: false)
                .getUserName,
            'useruid':
                Provider.of<Authentication>(context, listen: false).getUserUid,
            'userimage': Provider.of<FirebaseOperation>(context, listen: false)
                .getUserImage,
            'useremail': Provider.of<FirebaseOperation>(context, listen: false)
                .getUserEmail,
            'phone': Provider.of<FirebaseOperation>(context, listen: false)
                .getUserPhone,
            'time': Timestamp.now(),
            'usertalent': Provider.of<FirebaseOperation>(context, listen: false)
                .getUserTalent,
          });
  }
  showRewardss(BuildContext context,String postId){
    {
      return showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    Container(
                      width: 110.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: constantColors.whiteColor),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text(
                          'Awards',
                          style: TextStyle(
                              color: constantColors.blueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.63,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('awards')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentsnapshot) {
                                return ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
            if(documentsnapshot.data()['useruid']
            !=Provider.of<Authentication>(context,listen: false).getUserUid){
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: Alt(
                                                    userUid: documentsnapshot
                                                        .data()['useruid']),
                                                type: PageTransitionType
                                                    .bottomToTop));}
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            documentsnapshot.data()['userimage']),
                                      ),
                                    ),
                                    title: Text(
                                      documentsnapshot.data()['username'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    subtitle: Text(
                                      documentsnapshot.data()['useremail'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                    trailing: Provider.of<Authentication>(context,
                                        listen: false)
                                        .getUserUid ==
                                        documentsnapshot.data()['useruid']
                                        ? Container(
                                      height: 0.0,
                                      width: 0.0,
                                    )
                                        : MaterialButton(
                                        child: Text('Follow',
                                            style: TextStyle(
                                                color: constantColors
                                                    .blueGreyColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0)),
                                        onPressed: () {},
                                        color: constantColors.blueColor));

                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),

                  ],
                ),
                decoration: BoxDecoration(
                    color: constantColors.blueGreyColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0))),
              ),
            );
          });
    }

  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 110.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.63,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentsnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                            onTap: (){
          if(documentsnapshot.data()['useruid']
          !=Provider.of<Authentication>(context,listen: false).getUserUid){
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: Alt(
                                                          userUid: documentsnapshot
                                                              .data()['useruid']),
                                                      type: PageTransitionType
                                                          .bottomToTop));}
                                            },
                                            child: CircleAvatar(
                                              radius: 15.0,
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              backgroundImage: NetworkImage(
                                                  documentsnapshot
                                                      .data()['userimage']),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  documentsnapshot
                                                      .data()['username'],
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 12,
                                                ),
                                                onPressed: () {},
                                              ),
                                              Text('0',
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.reply,
                                                  color: constantColors
                                                      .yellowColor,
                                                  size: 12,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons
                                                .arrow_forward_ios_outlined),
                                            onPressed: () {},
                                            color: constantColors.blueColor,
                                            iconSize: 12,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                                documentsnapshot
                                                    .data()['comment'],
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: constantColors.redColor,
                                              size: 16,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: constantColors.darkColor
                                          .withOpacity(0.2),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 400.0,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20.0,
                          width: 300.0,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                              hintText: 'Add Comment...',
                            ),
                            controller: comment,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          onPressed: () {
                            print('add comment');
                            addComment(context, snapshot.data()['caption'],
                                    comment.text.trim())
                                .whenComplete(() {
                              comment.clear();
                              notifyListeners();
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0))),
            ),
          );
        });
  }

  showLikeSheet(BuildContext context, String potId) {
    return showModalBottomSheet(
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
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(potId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentsnapshot) {
                            return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
          if(documentsnapshot.data()['useruid']
          !=Provider.of<Authentication>(context,listen: false).getUserUid){
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: Alt(
                                                userUid: documentsnapshot
                                                    .data()['useruid']),
                                            type: PageTransitionType
                                                .bottomToTop));}
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        documentsnapshot.data()['userimage']),
                                  ),
                                ),
                                title: Text(
                                  documentsnapshot.data()['username'],
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                subtitle: Text(
                                  documentsnapshot.data()['useremail'],
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentsnapshot.data()['useruid']
                                    ? Container(
                                        height: 0.0,
                                        width: 0.0,
                                      )
                                    : MaterialButton(
                                        child: Text('Follow',
                                            style: TextStyle(
                                                color: constantColors
                                                    .blueGreyColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0)),
                                        onPressed: () {},
                                        color: constantColors.blueColor));
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * .50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showReward(BuildContext context, String postId) {
    return showModalBottomSheet(
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('awards')
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
                              .map((DocumentSnapshot documentsnapshot) {
                            return GestureDetector(
                              onTap: () async {
                                print('Reward user...');
                                await Provider.of<FirebaseOperation>(context,
                                        listen: false)
                                    .addReward(postId, {
                                  'username': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .getUserName,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'userimage': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .getUserImage,
                                  'useremail': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .getUserEmail,
                                  'phone': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .getUserPhone,
                                  'time': Timestamp.now(),
                                  'usertalent': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .getUserTalent,
                                  'award': documentsnapshot.data()['image']
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Container(
                                  height: 50.0,
                                  width: 50,
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
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }
}
