import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fcitalent/models/user.dart';
import 'package:provider/provider.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();

}

class _EditProfileState extends State<EditProfile> {
  UserModel user;
  final _scafladkey=GlobalKey<ScaffoldState>();
  bool isLoading =false;
  TextEditingController displaytextEditingController=new TextEditingController();
  TextEditingController biotextEditingController=new TextEditingController();
  TextEditingController emailextEditingController=new TextEditingController();
  TextEditingController phoneextEditingController=new TextEditingController();
  TextEditingController passwordtEditingController=new TextEditingController();
 bool  _ValdBio=true;
 bool _VaildDisplayName=true;
 bool  _Vaildphone=true;
 bool _Vaildemail=true;
  bool _Vailpassword=true;
  @override
  void initState(){
    super.initState();
   setState(() {
     getuser();
   });
  }
  getuser()async{
    setState(() {
      isLoading=true;
    });
   DocumentSnapshot doc=await FirebaseFirestore.instance.collection("users").doc(Provider.of<Authentication>(context, listen: false).getUserUid).get();

   user=UserModel.fromDocument(doc);
   displaytextEditingController.text=user.username;
   biotextEditingController.text=user.talent;
   emailextEditingController.text=user.email;
   phoneextEditingController.text=user.phone;
   passwordtEditingController.text=user.password;
   setState(() {
     isLoading=false;
   });
  }
  Container TextFieldDisplayName(){
  return Container(
    padding: EdgeInsets.all(10.0),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0),
          child: Text("UserName",style: TextStyle(color: Colors.grey),),),
        TextField(

          controller: displaytextEditingController,
          decoration: InputDecoration(
              hintText: "UserName",
              errorText:_VaildDisplayName?null:"UserName too short"
          ),
        )
      ],
    ) ,
  );

  }
  Container TextFieldemail(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0),
            child: Text("Email",style: TextStyle(color: Colors.grey),),),
          TextField(

            controller: emailextEditingController,
            decoration: InputDecoration(
                hintText: "Email",
                errorText:_Vaildemail?null:"Email too short"
            ),
          )
        ],
      ) ,
    );

  }
  Container TextFieldpass(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0),
            child: Text("Password",style: TextStyle(color: Colors.grey),),),
          TextField(
            obscureText: true,

            controller: passwordtEditingController,
            decoration: InputDecoration(
                hintText: "Password",
                errorText:_Vaildemail?null:"Password too short"
            ),
          )
        ],
      ) ,
    );

  }
  Container TextFieldphone(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0),
            child: Text("Phone",style: TextStyle(color: Colors.grey),),),
          TextField(

            controller: phoneextEditingController,
            decoration: InputDecoration(
                hintText: "Phone",
                errorText:_VaildDisplayName?null:"Phone too short"
            ),
          )
        ],
      ) ,
    );

  }
 Container TextFieldBio(){
   return Container(
     padding: EdgeInsets.all(10.0),
     child:Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Padding(padding: EdgeInsets.only(top: 10.0),
           child: Text("Talent",style: TextStyle(color: Colors.grey),),),
         TextField(
           controller: biotextEditingController,
           decoration: InputDecoration(
               hintText: "updade Talent",
                   errorText:_ValdBio?null:"Talent too long"
           ),
         )
       ],
     ) ,
   );

  }
  updataProfileData(){
    setState(() {
      passwordtEditingController.text.trim().length<5||
          passwordtEditingController.text.isEmpty
          ? _Vailpassword=false:true;
      displaytextEditingController.text.trim().length<3||
          displaytextEditingController.text.isEmpty
          ? _VaildDisplayName=false:true;
      emailextEditingController.text.contains('@')||
          emailextEditingController.text.isEmpty
          ? _Vaildemail=false:true;
     phoneextEditingController.text.trim().length<13||
         phoneextEditingController.text.isEmpty
          ?  _Vaildphone=false:true;
      biotextEditingController.text.trim().length>100

          ? _ValdBio=false:true;
    });
      if(_ValdBio &&_VaildDisplayName) {
        FirebaseFirestore.instance.collection("users").doc(Provider.of<Authentication>(context, listen: false).getUserUid).update({

          "username": displaytextEditingController.text,
          "talent": biotextEditingController.text,
          "useremail":emailextEditingController.text,
          "phone":phoneextEditingController.text,
          "userpassword":passwordtEditingController.text

        });
        SnackBar snackBar=SnackBar(content: Text("Profile Update"));
        _scafladkey.currentState.showSnackBar(snackBar);
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafladkey,
      backgroundColor: Colors.white ,
      appBar: AppBar(title: Text("EditProfile"),
      actions: [
        IconButton(icon: Icon(Icons.done),onPressed: (){
          Navigator.pop(context);
        },)
      ],),
      body: isLoading?new Center(child: CircularProgressIndicator(),):
          ListView(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: CircleAvatar(radius: 50.0,backgroundImage: CachedNetworkImageProvider(user.photoUrl),),
                  ),
                  TextFieldDisplayName(),
                  TextFieldBio(),
                  TextFieldemail(),
                  TextFieldphone(),
                  TextFieldpass(),

                  Padding(padding: EdgeInsets.all(10.0)),
                  RaisedButton(onPressed: (){
                    updataProfileData();
                  },
                  child: Text("Update Profile",style: TextStyle(color: Colors.blueAccent,fontSize: 20.0,fontWeight: FontWeight.bold),),
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  FlatButton.icon(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.cancel), label: Text("Logout",style: TextStyle(color: Colors.red,fontSize: 25.0,fontWeight: FontWeight.bold),) )
                ],
              )
            ],
          )
    );
  }
}
