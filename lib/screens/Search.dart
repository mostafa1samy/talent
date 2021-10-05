import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fcitalent/models//user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'Alt/alt.dart';



class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String valueChoose;
  List listSearch=['Talent','users','newers'];
  TextEditingController _searchtextEditingController=new TextEditingController();
  Future<QuerySnapshot> searchResult;
  handleSearch(value) {
    Future<QuerySnapshot> users = FirebaseFirestore.instance
        .collection("users")
        .where("talent", isGreaterThanOrEqualTo: value)
        .get();
    setState(() {
      searchResult = users;
    });
  }

  AppBar buildSearchFeild() {
    return AppBar(



      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search for Talent",
              prefixIcon: IconButton(
                onPressed: (){

                },

                icon: Icon(EvaIcons.searchOutline),

              ),
              suffixIcon: IconButton(
                onPressed: () {
                  clearSearch();
                },
                icon: Icon(Icons.clear),
              )),
          onFieldSubmitted: (value) {
            handleSearch(value);
          },
          controller: _searchtextEditingController,
        ),
      ),
    );
  }
  clearSearch(){
    _searchtextEditingController.clear();

  }
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              "assets/images/search.svg",
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "Find Talent",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0),
            )
          ],
        ),
      ),
    );
  }

  buildResultSearch() {
    return FutureBuilder<QuerySnapshot>(
        future: searchResult,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          List<userResult> searchdata = [];
          snapshot.data.docs.forEach((doc) {


            UserModel user = UserModel.fromDocument(doc);

            searchdata.add(userResult(userModel: user));
          });
          return ListView(children: searchdata,);
        });



  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: buildSearchFeild(),
        body: searchResult != null ? buildResultSearch() : buildNoContent(),
      ),
    );
  }
}
class userResult extends StatelessWidget {
  final UserModel  userModel;
  userResult({this. userModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            GestureDetector(onTap: (){},
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: Alt(
                                userUid:userModel.id),
                            type: PageTransitionType
                                .bottomToTop));
                  },
                  child: CircleAvatar(backgroundColor: Colors.grey,
                      backgroundImage:  CachedNetworkImageProvider(userModel.photoUrl)),
                ),
                title: new Text(userModel.username,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                subtitle: new Text(userModel.talent,style: TextStyle(color: Colors.grey,),),
              )
              ,),
            Divider()
          ],
        ),
      ),
    );
  }
}
