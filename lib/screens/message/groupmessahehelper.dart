import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart'as timago;

class GroupingMessagingHelper with ChangeNotifier {
  String lastmessagetime;
  String get getlastmessagetime=>lastmessagetime;
  bool hasjoinmember=false;
  bool get gethasjoinmember=>hasjoinmember;
  ConstantColors constantColors = new ConstantColors();
  logOtDialog(BuildContext context,String room) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Leave $room  ?',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor,
                        color: constantColors.whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
              ),
              MaterialButton(
                color: constantColors.redColor,
                onPressed: () {
                 FirebaseFirestore.instance.collection('chatrooms').doc(
                   room
                 ).collection('members').doc(
                   Provider.of<Authentication>(context,listen: false).getUserUid
                 ).delete().whenComplete(() {
                   Navigator.pushReplacement(
                       context,
                       PageTransition(
                           child: Home(),
                           type: PageTransitionType.bottomToTop));
                 });
                },
                child: Text('yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }
  showmessage(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminuseruid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            reverse: true,
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  showlastmessagetime(documentSnapshot.data()['time']);
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height:documentSnapshot.data()['message']!= null ? MediaQuery.of(context).size.height * 0.125: MediaQuery.of(context).size.height *.2
                  ,child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 20,bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              documentSnapshot
                                                  .data()['username'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: constantColors
                                                      .greenColor),
                                            ),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserUid ==
                                                  adminuseruid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    color: constantColors
                                                        .yellowColor,
                                                    size: 14,
                                                  ),
                                                )
                                              : Container(
                                                  height: 0.0,
                                                  width: 0.0,
                                                )
                                        ],
                                      ),
                                    ),
                                    documentSnapshot.data()['message']!= null ?
                                    Text(
                                      documentSnapshot.data()['message'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: constantColors.whiteColor),
                                    ):Padding(
                                      padding: const EdgeInsets.only(top:8.0),
                                      child: Container(
                                        height: 90,
                                        width: 100,
                                        child: Image.network(documentSnapshot.data()['sticker']),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Text(getlastmessagetime,style: TextStyle(color: constantColors.whiteColor,fontSize: 8),),
                                    )
                                  ],
                                ),
                              ),
                              constraints: BoxConstraints(
                                  maxHeight:documentSnapshot.data()['message']!=null?
                                      MediaQuery.of(context).size.height * 0.1:MediaQuery.of(context).size.height * 0.42,
                                  maxWidth:documentSnapshot.data()['message']!=null?
                                      MediaQuery.of(context).size.width * .8: MediaQuery.of(context).size.height * 0.9,),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid ==
                                          documentSnapshot.data()['useruid']
                                      ? constantColors.blueGreyColor
                                          .withOpacity(0.8)
                                      : constantColors.blueGreyColor),
                            )
                            ],
                        ),
                      ),

                      Positioned(
                          top: 5,
                          child:Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid ==
                              documentSnapshot.data()['useruid']? Container(
                        child: Column(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: constantColors.blueColor,
                                  size: 16,
                                ),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.trashAlt,
                                  color: constantColors.redColor,
                                  size: 12,
                                ),
                                onPressed: () {})
                          ],
                        ),
                      ):Container(width: 0.0,height: 0.0,)),
                      Positioned(

                          left: 40,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot.data()['useruid']
                              ? Container(
                                  width: 0.0,
                                  height: 0.0,
                                )
                              : CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userimage']),
                                ))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  sendmessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController message) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': message.text,
      'time': Timestamp.now(),
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'useremail':
          Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
      'usertalent':
          Provider.of<FirebaseOperation>(context, listen: false).getUserTalent,
      'phone':
          Provider.of<FirebaseOperation>(context, listen: false).getUserPhone,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
    });
  }
  Future checkifjoined(BuildContext context,String chatroomname,String chatroomadminuid)async{
    return FirebaseFirestore.instance.collection('chatrooms').doc(
      chatroomname
    ).collection('members').doc(
      Provider.of<Authentication>(context,listen: false).getUserUid
    ).get().then((value) {
      hasjoinmember=false;
      print('inital state$hasjoinmember');
      if(value.data()['joined']!=null){
        hasjoinmember=value.data()['joined'];
        print('finalstate $hasjoinmember');
        notifyListeners();
      }
      if( Provider.of<Authentication>(context,listen: false).getUserUid==chatroomadminuid){
        hasjoinmember=true;
        notifyListeners();
      }
    });
  }
  asktojoin(BuildContext context,String roomname){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        backgroundColor: constantColors.darkColor,
        title: Text('join $roomname',style: TextStyle(
          fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor
        ),),
        actions: [
          MaterialButton(onPressed: (){
            Navigator.pushReplacement(context,PageTransition(child: Home(), type:PageTransitionType.bottomToTop));
          },child: Text('No',style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: constantColors.whiteColor,
              color: constantColors.whiteColor
          )),),
          MaterialButton(onPressed: ()async{
            FirebaseFirestore.instance.collection('chatrooms').doc(
              roomname
            ).collection('members').doc(
              Provider.of<Authentication>(context,listen: false).getUserUid
            ).set({
              'joined':true,
              'time': Timestamp.now(),
              'userimage':
              Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
              'username':
              Provider.of<FirebaseOperation>(context, listen: false).getUserName,
              'useremail':
              Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
              'usertalent':
              Provider.of<FirebaseOperation>(context, listen: false).getUserTalent,
              'phone':
              Provider.of<FirebaseOperation>(context, listen: false).getUserPhone,
              'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,

            }).whenComplete(() {
              Navigator.pop(context);
            });
          },child: Text('Yes',style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.bold,

              color: constantColors.whiteColor
          )),
          color: constantColors.blueColor,)
        ],
      );

    });
  }
  howstikers(BuildContext context,String chatroomid ){
    return showModalBottomSheet(context: context, builder: (context){
      return AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,

        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 105.0),
            child: Divider(
              thickness: 4,
              color: constantColors.whiteColor,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  height: 30.0,
                  width: 30.0,
                  child: Image.asset('assets/icons/sunflower.png'),
                ),

              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stickers').snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                }
                else{
                  return GridView(
                      children: snapshot.data.docs.map((DocumentSnapshot documentsnpshot){
                        return GestureDetector(
                          onTap: (){
                            sendstickers(context,documentsnpshot.data()['image'],chatroomid);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Image.network(documentsnpshot.data()['image']),
                          ),
                        );
                      }).toList(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                  ));
                }
              },
            ),
          )
        ],
        ),
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(12.0),topLeft: Radius.circular(12.0))
        ),
      );
    });
  }
  sendstickers(BuildContext context,String stckerimageurl,String chatroomid)async{
    await FirebaseFirestore.instance.collection('chatrooms').doc(
      chatroomid
    ).collection('messages').
    add({
    'sticker':stckerimageurl,
      'time': Timestamp.now(),
      'userimage':
      Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'username':
      Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'useremail':
      Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
      'usertalent':
      Provider.of<FirebaseOperation>(context, listen: false).getUserTalent,
      'phone':
      Provider.of<FirebaseOperation>(context, listen: false).getUserPhone,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
    });
  }
  showlastmessagetime(dynamic timedata){
    Timestamp time=timedata;
    DateTime dateTime=time.toDate();
    lastmessagetime=timago.format(dateTime);
    notifyListeners();
  }

}
