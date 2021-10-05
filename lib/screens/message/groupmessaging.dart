import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/screens/Profile/Profilehlpers.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'groupmessahehelper.dart';

class GroupingMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupingMessage({@required this.documentSnapshot});

  @override
  _GroupingMessageState createState() => _GroupingMessageState();
}

class _GroupingMessageState extends State<GroupingMessage> {


  TextEditingController messag=new TextEditingController();

  ConstantColors constantColors = new ConstantColors();
  @override
  void initState() {
    Provider.of<GroupingMessagingHelper>(context,listen: false).checkifjoined(context,
        widget.documentSnapshot.id, widget.documentSnapshot.data()['useruid']).whenComplete(() async{
          if(Provider.of<GroupingMessagingHelper>(context,listen: false).gethasjoinmember==false){
            Timer(
              Duration(milliseconds: 10),
                ()=>Provider.of<GroupingMessagingHelper>(context,listen: false).asktojoin(context, widget.documentSnapshot.id)
            );
          }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(EvaIcons.logOutOutline,color: constantColors.redColor,), onPressed:(){
            Provider.of<GroupingMessagingHelper>(context,listen: false).logOtDialog(context,widget.documentSnapshot.id);
          }),
          Provider.of<Authentication>(context,listen: false).getUserUid==widget.documentSnapshot.data()['useruid']?IconButton(
              icon: Icon(EvaIcons.moreVertical,color: constantColors.redColor,) , onPressed: (){}):Container(
            width: 0.0
            ,
            height: 0.0,
          )
        ],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: Home(),
                      type: PageTransitionType.leftToRight));
            }),
        centerTitle: true,
        backgroundColor: constantColors.darkColor.withOpacity(.6),
        title: Container(
          child: Row(
            children: [
              CircleAvatar(

                backgroundImage: NetworkImage(widget.documentSnapshot.data()['roomavatar']),
                backgroundColor: constantColors.darkColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.documentSnapshot.data()['roomname'],style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                   StreamBuilder<QuerySnapshot>(
                       stream: FirebaseFirestore.instance.collection('chatrooms').doc(
                         widget.documentSnapshot.id
                       ).collection('members').snapshots(),
                       builder: (context,snapshot){
                         if(snapshot.connectionState==ConnectionState.waiting){
                           return Center(child: CircularProgressIndicator(),);
                         }
                         else{
                           return  Text('${snapshot.data.docs.length.toString() }members',style: TextStyle(
                           color: constantColors.greenColor,
                               fontSize: 10,
                               fontWeight: FontWeight.bold),);
                         }

                       })


                  ],
                ),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width*.5,
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupingMessagingHelper>(context,listen: false).showmessage(context, widget.documentSnapshot,widget.documentSnapshot.data()['useruid']),
               // color: constantColors.redColor,
                height: MediaQuery.of(context).size.height*.8 ,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),curve: Curves.bounceIn,),
              Container(
                child: Padding(
                  padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Provider.of<GroupingMessagingHelper>(context,listen: false).howstikers(context,widget.documentSnapshot.id);

                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: constantColors.transperant,
                          backgroundImage: AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          child: TextField(
                            controller: messag,
                            style:  TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi',
                              hintStyle:  TextStyle(
                                  color: constantColors.greenColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)
                            ),
                          ),
                          width: MediaQuery.of(context).size.width*0.75,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        onPressed: (){
                          if(messag.text.isNotEmpty){
                            Provider.of<GroupingMessagingHelper>(context,listen: false).sendmessage(context, widget.documentSnapshot, messag);

                          }

                        },child: Icon(Icons.send_sharp,color: constantColors.whiteColor,),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
