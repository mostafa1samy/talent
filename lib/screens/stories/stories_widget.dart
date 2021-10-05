import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/alt.dart';
import 'package:fcitalent/screens/Alt/altProfile.dart';
import 'package:fcitalent/screens/HomePage/home.dart';
import 'package:fcitalent/screens/stories/stories_helper.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class StoryWidget{
  ConstantColors constantColors = new ConstantColors();
  TextEditingController storyHightLightTitile=new TextEditingController();
  addStory(BuildContext context){
    return showModalBottomSheet(context: context, builder:(context){
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Divider(
                thickness: 4.0,
                color: constantColors.whiteColor,

          ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constantColors.blueColor,
                  onPressed: (){
                    Provider.of<StoriesHelper>(context,listen: false).slectStoryImage(context,ImageSource.gallery).whenComplete(() {
                      //Navigator.pop(context);
                    });

                  },
                  child: Text('Gallary',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                MaterialButton(
                  color: constantColors.blueColor,
                  onPressed: (){
                    Provider.of<StoriesHelper>(context,listen: false).slectStoryImage(context,ImageSource.camera).whenComplete(() {
                      Navigator.pop(context);
                    });

                  },
                  child: Text('Camera',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),
                )
              ],
            )


          ],
        ),
        height: MediaQuery.of(context).size.height *0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0))
        ),

      );
    });
  }
  previewStoryImage(BuildContext context,File storyImage){
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor
        ),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.file(storyImage),
            ),
            Positioned(
              top:700.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      onPressed: (){
                      addStory(context);

                    },heroTag: 'Reselect image',
                    child: Icon(
                      FontAwesomeIcons.backspace,color: constantColors.whiteColor,
                    ),),
                    FloatingActionButton(
                      backgroundColor: constantColors.blueColor,
                      onPressed: (){
                      Provider.of<StoriesHelper>(context,listen: false).uploadStoryImage(context).whenComplete(()async {
                       try{
                       if(Provider.of<StoriesHelper>(context,listen: false).getStoryImageUrl!=null){
                         await FirebaseFirestore.instance.collection('stories').
                         doc(Provider.of<Authentication>(context,listen: false).getUserUid).set(
                             {
                               'image':Provider.of<StoriesHelper>(context,listen: false).getStoryImageUrl,
                               'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
                               'userimage':Provider.of<FirebaseOperation>(context,listen: false).getUserImage,
                               // 'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
                               'time':Timestamp.now(),
                               'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                             }
                         ).whenComplete(() {
                           Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.bottomToTop));
                         });
                       }
                       else{
                         return showModalBottomSheet(context: context, builder:(context){
                           return Container(
                             decoration: BoxDecoration(
                               color: constantColors.darkColor
                             ),
                             child: Center(
                               child: MaterialButton(
                                 onPressed: () async{
                                   await FirebaseFirestore.instance.collection('stories').
                                   doc(Provider.of<Authentication>(context,listen: false).getUserUid).set(
                                       {
                                         'image':Provider.of<StoriesHelper>(context,listen: false).getStoryImageUrl,
                                         'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
                                         'userimage':Provider.of<FirebaseOperation>(context,listen: false).getUserImage,
                                         // 'username':Provider.of<FirebaseOperation>(context,listen: false).getUserName,
                                         'time':Timestamp.now(),
                                         'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                                       }).whenComplete(() {
                                     Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.bottomToTop));
                                   });

                                 },
                                 child: Text('Upload Story',style: TextStyle(color:constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize:16 ),),
                               ),
                             ),
                           );
                         });
                       }
                       }
                       catch(e){
                         print(e.toString());
                       }

                      });

                    },heroTag: 'Confirm image',
                      child: Icon(
                        FontAwesomeIcons.check,color: constantColors.whiteColor
                      ),)
                  ],
                ),
              ),
            )

          ],
        ),


      );
    });

  }
  addHighlights(BuildContext context,String storyImage){
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(color: constantColors.whiteColor,thickness: 4.0,),
              ),Text('Add To Exiting Album',style: TextStyle(
                  color: constantColors.yellowColor,fontSize: 14,fontWeight: FontWeight.bold
              ),),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
               // color: constantColors.redColor,

              ),Text('Create New Album',style: TextStyle(
                  color: constantColors.greenColor,fontSize: 14,fontWeight: FontWeight.bold
              ),),Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chatroomicons').snapshots(),
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
                                Provider.of<StoriesHelper>(context,listen: false)
                                    .convertHightlightIcon(documentSnapshot.data()['image']);
                           /*     Navigator.pushReplacement(context, PageTransition(child: Stories(documentSnapshot: documentSnapshot,),
                                    type: PageTransitionType.leftToRight));*/

                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(

                                  height: 50.0,
                                  width:50.0,
                                 child: Image.network(documentSnapshot.data()['image']),
                                ),
                              )


                          );
                        }).toList(),

                      );

                    }
                  },
                ),

              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: storyHightLightTitile,
                        style: TextStyle(
        color: constantColors.whiteColor,fontSize: 14,fontWeight: FontWeight.bold
        ) ,
                        decoration: InputDecoration(
                          hintStyle:  TextStyle(
        color: constantColors.blueColor,fontSize: 14,fontWeight: FontWeight.bold
        ),
        hintText: 'Add Album Title...'
                        ),
                      ),
                    ),
                    FloatingActionButton(onPressed: (){
                      if(storyHightLightTitile.text.isNotEmpty){
                        Provider.of<StoriesHelper>(context,listen: false).addStoryToNewAlbum(context,
                            Provider.of<Authentication>(context,listen: false).getUserUid,
                            storyHightLightTitile.text, storyImage);
                      }
                      else{
                        return showModalBottomSheet(context: context, builder: (context){
                          return Container(
                            color:constantColors.darkColor,
                            height:100.0,
                            width:400.0,
                            child:Center(
                              child:Text('Add album title')
                            )
                          );
                        });
                      }


                    },child: Icon(FontAwesomeIcons.check,color: constantColors.whiteColor,),backgroundColor: constantColors.blueColor,)
                  ],
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height*0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(12.0)),
        ),
      );
    });
  }
  showVieers(BuildContext context,String storyId,String personId){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        child: Column(
          children: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150),
        child: Divider(color: constantColors.whiteColor,thickness: 4.0,),),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              child:StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('stories').doc(
                     storyId
                  ).collection('seen').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      return ListView(
                        children: snapshot.data.docs.map((DocumentSnapshot documentsnapshot){
                          Provider.of<StoriesHelper>(context,listen: false).storyTimepost(documentsnapshot.data()['time']);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(documentsnapshot.data()['userimage']),
                              radius: 25,
                              backgroundColor: constantColors.darkColor,
                            ),
                            trailing: IconButton(
                              onPressed: (){
                                Navigator.pushReplacement(context,PageTransition(child: Alt(userUid: documentsnapshot.data()['useruid'],
                                ), type:PageTransitionType.bottomToTop ));
                              },
                              icon: Icon(FontAwesomeIcons.arrowAltCircleRight,color: constantColors.yellowColor,),
                            ),
                            title: Text(documentsnapshot.data()['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,
                            fontSize: 16),),
                            subtitle:  Text(Provider.of<StoriesHelper>(context,listen: false).getlastseentime.toString(),style: TextStyle(color: constantColors.greenColor,fontWeight: FontWeight.bold,
                                fontSize: 12),),
                          );
                        }).toList(),
                      );
                    }
                  }) ,
            )
          ],
        ),
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.darkColor,borderRadius: BorderRadius.circular(12.0)),
      );
    });
  }
}