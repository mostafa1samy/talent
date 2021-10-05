import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/alt.dart';
import 'package:fcitalent/screens/stories/stories.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:fcitalent/utils/Postoption.dart';
import 'package:fcitalent/utils/Uploadpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelper with ChangeNotifier {
  String va;
  ConstantColors constantColors = new ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.camera_enhance_rounded,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            })
      ],
      title: RichText(
        text: TextSpan(
            text: 'Talent',
            style: TextStyle(color: constantColors.whiteColor, fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                  text: 'Feed',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('stories').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child:CircularProgressIndicator()
                    );
                  }
                  else{
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot){
                        return GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context, PageTransition(child: Stories(documentSnapshot: documentSnapshot,),
                                type: PageTransitionType.leftToRight));

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: CircleAvatar(

                                backgroundImage: NetworkImage(documentSnapshot.data()['userimage']),
                                backgroundColor: constantColors.darkColor,
                                radius: 25,
                               ),

                              height: 30.0,
                              width:50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: constantColors.blueColor,width:2.0
                                )
                              ),
                            ),
                          )


                        );
                      }).toList(),

                    );

                  }
                },
              ),
              height: MediaQuery.of(context).size.height* 0.06,
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').orderBy('time',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 500.0,
                        width: 400.0,
                        child: Lottie.asset('assets/animations/loading.json'),
                      ),
                    );
                  } else {
                   return loadPost(context,snapshot);
                  }
                },
              ),
              height: MediaQuery.of(context).size.height*0.9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0))),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

    return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot documentsnapshot) {

        Provider.of<PostOption>(context,listen: false).showTimeGo(documentsnapshot.data()['time']);

        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(documentsnapshot.data()['useruid']!=Provider.of<Authentication>(context,listen: false).getUserUid){
                          Navigator.pushReplacement(context,PageTransition(child: Alt(userUid: documentsnapshot.data()['useruid'],), type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: documentsnapshot.data()['userimage']!=null?
                      CircleAvatar(
                        backgroundColor: constantColors.blueGreyColor,
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(documentsnapshot.data()['userimage'])
                            ,
                      ):CircleAvatar(radius: 20.0,backgroundColor: constantColors.blueGreyColor,)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
//                        Container(
//                          child: Text(
//                            documentsnapshot.data()['username'],
//                            style: TextStyle(
//                                color: constantColors.greenColor,
//                                fontWeight: FontWeight.bold,
//                                fontSize: 16.0),
//                          ),
//                        ),
                            Container(
                              child: RichText(text: TextSpan(text: documentsnapshot.data()['username'],style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                                  children: <TextSpan>[
                                    TextSpan(text:' ,${Provider.of<PostOption>(context,listen: false).getimageTimePostId.toString()}',style: TextStyle(color: constantColors.lightColor.withOpacity(0.8)))
                                  ]
                              ),

                              ),
                            ),
                            Container(
                              child: Text(
                                documentsnapshot.data()['caption'],
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                            Container(
                              child: Text(
                                documentsnapshot.data()['usertalent'],
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Container(width: MediaQuery.of(context).size.width*.2,
                    height: MediaQuery.of(context).size.height*0.05,
                    // color: constantColors.redColor,
                      child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('posts').doc(
                        documentsnapshot.data()['caption']
                      ).collection('awards').snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(child:CircularProgressIndicator());
                        }
                        else{
                          return ListView(scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs.map((DocumentSnapshot documentsnapshot ){
                            return Container(
                              height: 30.0,
                              width: 30.0,
                              child: Image.network(documentsnapshot.data()['award']),
                            );
                          }).toList(),
                          );
                        }
                      },),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.46,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(

                  child:Image.network(documentsnapshot.data()['postimage'],scale: 2,)
                    ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: (){
                              Provider.of<PostOption>(context,listen: false).showLikeSheet(context,documentsnapshot.data()['caption']);
                            },
                            onTap: (){
                              print('add lik');
                              Provider.of<PostOption>(context,listen: false).addLike(context,documentsnapshot.data()['caption'],
                                  Provider.of<Authentication>(context,listen: false).getUserUid);
                            },
                            child: Icon(FontAwesomeIcons.heart,color: constantColors.redColor,size: 22.0,),),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts').doc(documentsnapshot.data()['caption'])
                              .collection('likes').snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                else{
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(snapshot.data.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Provider.of<PostOption>(context,listen: false).showCommentsSheet(context,
                                  documentsnapshot, documentsnapshot.data()['caption']);
                            },
                            child: Icon(FontAwesomeIcons.comment,color: constantColors.blueColor,size: 22.0,),),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts').doc(documentsnapshot.data()['caption'])
                                  .collection('comments').snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                else{
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(snapshot.data.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          GestureDetector(
                            onLongPress: (){
                              Provider.of<PostOption>(context,listen: false).
                              showRewardss(context, documentsnapshot.data()['caption']);
                            },
                            onTap: (){
                              Provider.of<PostOption>(context,listen: false).showReward(context,documentsnapshot.data()['caption']);
                            },
                            child: Icon(FontAwesomeIcons.award,color: constantColors.yellowColor,size: 22.0,),),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts').doc(documentsnapshot.data()['caption'])
                                  .collection('awards').snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                else{
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(snapshot.data.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                      Spacer(),
                      Provider.of<Authentication>(context,listen: false).getUserUid==documentsnapshot.data()['useruid']?IconButton(
                          icon: Icon(EvaIcons.moreVertical,color: constantColors.whiteColor,),
                          onPressed: (){
                            Provider.of<PostOption>(context,listen: false).showPostOption(context,documentsnapshot.data()['caption']);
                          }):Container(height: 0.0,width: 0.0,)

                  ],),
                ),
              ),

            ],
          ),
        );
      }).toList(),
    );
  }
}
