import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/alt.dart';
import 'package:fcitalent/screens/Feed/Feed.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:fcitalent/utils/Postoption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AlterProfile with ChangeNotifier{
  ConstantColors constantColors = new ConstantColors();
  Widget appBar(BuildContext context){
    return AppBar(
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded,color: constantColors.whiteColor,),onPressed: (){
        Navigator.pushReplacement(context,PageTransition(child: Feed(), type: PageTransitionType.bottomToTop));
      },),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(icon: Icon(EvaIcons.moreVertical,color: constantColors.whiteColor,),onPressed: (){
          Navigator.pushReplacement(context,PageTransition(child: Home(), type: PageTransitionType.bottomToTop));
        },),

      ],
      title: RichText(
        text: TextSpan(text: 'The',style: TextStyle(color: constantColors.whiteColor,fontSize: 20.0,fontWeight: FontWeight.bold),
        children: <TextSpan>[
            TextSpan(text: 'Talent',style: TextStyle(color: constantColors.blueColor,fontSize: 20.0,fontWeight: FontWeight.bold)),
        //TextSpan(text: 'The',style: TextStyle(color: constantColors.whiteColor,fontSize: 20.0,fontWeight: FontWeight.bold))
        ]),
      ),
    );

  }
  Widget divider(){
    return Center(
      child: SizedBox(height: 25.0,width: 350.0,child: Divider(color: constantColors.whiteColor,),),
    );
  }
  Widget middleProfile(BuildContext context,dynamic snapshot){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(FontAwesomeIcons.userAstronaut,color: constantColors.yellowColor,size: 10,),
                Text('Recently Added',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: constantColors.whiteColor),)
              ],),
          ),
          Padding(padding: EdgeInsets.only(top: 8.0),child: Container(
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: constantColors.darkColor.withOpacity(0.4),borderRadius: BorderRadius.circular(15.0)),
          ),)
        ],
      ),
    );
  }
  Widget footerProfile(BuildContext context,dynamic snapshot,String us){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(us)
          .collection('posts').snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return GridView(
                  children: snapshot.data.docs.map((DocumentSnapshot documentsnapshot){
                    return GestureDetector(
                      onTap: (){showPostDetails(context,documentsnapshot);},
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.45,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: Image.network(documentsnapshot.data()['postimage']),
                          ),
                        ),
                      ),
                    );
                  } ).toList(),

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
            }
          },
        ),
        height: MediaQuery.of(context).size.height*0.45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.darkColor.withOpacity(0.4),borderRadius: BorderRadius.circular(5.0)),

      ),
    );
  }
  FollowedNatovication(BuildContext context,String name){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4.0,
                color: constantColors.whiteColor,
              ),
            ),
            Text('Followed  $name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: constantColors.whiteColor),)
          ],),
        ),
        height: MediaQuery.of(context).size.height*0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.darkColor.withOpacity(0.4),borderRadius: BorderRadius.circular(12.0)),


      );
    });
  }
  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context, 
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.data()['useruid'])
                    .collection('followers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentsnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListTile(
                            onTap: () {
                              if(documentsnapshot.data()['useruid']
                                  !=Provider.of<Authentication>(context,listen: false).getUserUid){
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Alt(
                                          userUid:
                                          documentsnapshot.data()['useruid'],
                                        ),
                                        type: PageTransitionType.topToBottom));
                              }

                            },
                            trailing:documentsnapshot.data()['useruid']
                                ==Provider.of<Authentication>(context,listen: false).getUserUid?Container(height: 0.0,width: 0.0,):
                            MaterialButton(
                              onPressed: () {},
                              color: constantColors.blueColor,
                              child: Text('Unfollow',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(
                                  documentsnapshot.data()['userimage']),
                            ),
                            title: Text(documentsnapshot.data()['username'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(documentsnapshot.data()['useremail'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                          );
                        }
                      }).toList(),
                    );
                  }
                }),
          );
        });
  }
  Widget headerProfile(BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,String userUId){
    return SizedBox(
      height: MediaQuery.of(context).size.height*.37,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                // color: constantColors.redColor,
                height: 220.0,
                width: 200.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 60.0,
                        backgroundImage: NetworkImage(snapshot.data['userimage']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: constantColors.greenColor,
                            size: 14,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              snapshot.data['useremail'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 200.0,
                //color: constantColors.yellowColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              checkFollowersSheet(context,snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(15.0)),
                              height: 70.0,
                              width: 80.0,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('users').doc(
                                          snapshot.data.data()['useruid']
                                      ).collection('followers').snapshots(),
                                      builder: (context,snapshot){
                                        if(snapshot.connectionState==ConnectionState.waiting){
                                          return Center(child:CircularProgressIndicator());
                                        }
                                        else{
                                          return Text(
                                            snapshot.data.docs.length.toString(),
                                            style: TextStyle(
                                                color: constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0),
                                          );
                                        }
                                      }),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(15.0)),
                            height: 70.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('users').doc(
                                      snapshot.data.data()['useruid']
                                    ).collection('following').snapshots(),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState==ConnectionState.waiting){
                                        return Center(child:CircularProgressIndicator());
                                      }
                                      else{
                                        return Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        );
                                      }
                                    }),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(15.0)),
                        height: 70.0,
                        width: 80.0,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').doc(
                                    snapshot.data.data()['useruid']
                                ).collection('posts').snapshots(),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return Center(child:CircularProgressIndicator());
                                  }
                                  else{
                                    return Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    );
                                  }
                                }),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )


            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(onPressed: (){
                  Provider.of<FirebaseOperation>(context,listen: false).folowuser(userUId,


                     Provider.of<Authentication>(context,listen: false).getUserUid,
                     {
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
                     },
                      Provider.of<Authentication>(context,listen: false).getUserUid,
                      userUId,
                      {
                        'username':snapshot.data.data()['username'],
                        'userimage':snapshot.data.data()['userimage'],
                        'useremail':snapshot.data.data()['useremail'],
                        'usertalent':snapshot.data.data()['usertalent'],
                        'phone':snapshot.data.data()['phone'],
                        'useruid':snapshot.data.data()['useruid'],
                        'time': Timestamp.now(),
                      }).whenComplete(() {
                    FollowedNatovication(context,snapshot.data.data()['username']);
                  });
                },child: Text(
                  'Follow',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),color: constantColors.blueColor,),
                MaterialButton(
                    color: constantColors.blueColor,
                  onPressed: (){},child: Text(
                  'Message',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),)
              ],
            ),
          )


        ],
      ),
    );
  }
  showPostDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        child:Column(children: [
         Container(
            height: MediaQuery.of(context).size.height*0.45,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: Image.network(documentSnapshot.data()['postimage']),
            ),
          ),
          Text(documentSnapshot.data()['caption'],style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0),),
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
                            Provider.of<PostOption>(context,listen: false).showLikeSheet(context,documentSnapshot.data()['caption']);
                          },
                          onTap: (){
                            print('add lik');
                            Provider.of<PostOption>(context,listen: false).addLike(context,documentSnapshot.data()['caption'],
                                Provider.of<Authentication>(context,listen: false).getUserUid);
                          },
                          child: Icon(FontAwesomeIcons.heart,color: constantColors.redColor,size: 22.0,),),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('posts').doc(documentSnapshot.data()['caption'])
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
                                documentSnapshot, documentSnapshot.data()['caption']);
                          },
                          child: Icon(FontAwesomeIcons.comment,color: constantColors.blueColor,size: 22.0,),),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('posts').doc(documentSnapshot.data()['caption'])
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
                            Provider.of<PostOption>(context,listen: false).showRewardss(context, documentSnapshot.data()['caption']);
                          },
                          onTap: (){
                            Provider.of<PostOption>(context,listen: false).showReward(context,documentSnapshot.data()['caption']);
                          },
                          child: Icon(FontAwesomeIcons.award,color: constantColors.yellowColor,size: 22.0,),),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('posts').doc(documentSnapshot.data()['caption'])
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


                ],),
            ),
          ),

        ],),
        height: MediaQuery.of(context).size.height*.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(15.0)),
      );
    });
    
  }

}