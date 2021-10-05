import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/screens/stories/stories_helper.dart';
import 'package:fcitalent/screens/stories/stories_widget.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  Stories({@required this.documentSnapshot});

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final StoryWidget storyWidget=new StoryWidget();
  ConstantColors constantColors = new ConstantColors();
 @override
  void initState() {
   Provider.of<StoriesHelper>(context,listen: false).storyTimepost(widget.documentSnapshot.data()['time']);
   Provider.of<StoriesHelper>(context,listen: false)
       .addSeenStemp(context, widget.documentSnapshot.id, Provider.of<Authentication>(context,listen: false)
       .getUserUid, widget.documentSnapshot);
   Timer(Duration(seconds: 15),
           ()=> Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.bottomToTop)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: GestureDetector(
        onPanUpdate: (update){
          if(update.delta.dx>0){
            print(update);
            Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.bottomToTop));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.documentSnapshot.data()['image'],fit: BoxFit.contain,),

                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 30.0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: CircleAvatar(

                          backgroundColor: constantColors.darkColor,
                          backgroundImage: NetworkImage(widget.documentSnapshot.data()['userimage']),
                          radius: 25.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.55,constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width*0.9,

                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.documentSnapshot.data()['username'],style: TextStyle(
                                color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16
                              ),),
                              Text(Provider.of<StoriesHelper>(context,listen: false).getstoryTime,style: TextStyle(
                                  color: constantColors.greenColor,fontWeight: FontWeight.bold,fontSize: 12
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Provider.of<Authentication>(context,listen: false).getUserUid==widget.documentSnapshot.data()['useruid']?
                          GestureDetector(
                            onTap: (){
                              storyWidget.showVieers(context, widget.documentSnapshot.id,
                              widget.documentSnapshot.data()['useruid']);
                            },
                            child: Container(
                              height: 30.0,
                              width: 53.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(FontAwesomeIcons.solidEye,color: constantColors.whiteColor,size: 16,),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('stories').doc(
                                        widget.documentSnapshot.id
                                      ).collection('seen').snapshots(),
                                      builder: (context,snapshot){
                                        if(snapshot.connectionState==ConnectionState.waiting){
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        else{
                                          return Text(snapshot.data.docs.length.toString(),style: TextStyle(
                                              color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 12
                                          ));
                                        }
                                      })
                                ],
                              ),
                            ),


                          ):Container(height: 0.0,width: 0.0,),
                      SizedBox(
                        height: 30.0,
                        width: 30,
                        child:CircularCountDownTimer(
                          isTimerTextShown: false,
                          duration: 15,
                          fillColor: constantColors.blueColor,
                          height: 20.0,
                          width: 20.0,
                          color: constantColors.darkColor,

                        ),


                      ),
                      IconButton(icon: Icon(EvaIcons.moreVertical,color: constantColors.whiteColor,), onPressed: (){
                        return showMenu(
                            color: constantColors.darkColor,
                            context: context, position: RelativeRect.fromLTRB(300.0, 70.0, 0.0, 0.0), items: [

                          PopupMenuItem(

                              child: FlatButton.icon(
                              color: constantColors.blueColor,
                              onPressed: (){
                                storyWidget.addHighlights(context, widget.documentSnapshot.data()['image']);
                              }, icon:Icon(FontAwesomeIcons.archive,color: constantColors.whiteColor,
                          ), label: Text('Add To Highlights',style: TextStyle(
                            color: constantColors.whiteColor
                          ),))),
                          PopupMenuItem(child: FlatButton.icon(
                              color: constantColors.redColor,
                              onPressed: (){
                                FirebaseFirestore.instance.collection('stories')
                                    .doc(Provider.of<Authentication>(context,listen: false).getUserUid).delete().whenComplete((){
                                  Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.bottomToTop));

                                });
                              }, icon:Icon(FontAwesomeIcons.removeFormat,color: constantColors.whiteColor,
                          ), label: Text('Delete',style: TextStyle(
                              color: constantColors.whiteColor
                          ),))),


                        ]);

                      })
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
