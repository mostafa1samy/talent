import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Alt/altProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Alt extends StatelessWidget {
  ConstantColors constantColors = new ConstantColors();
  final String userUid;
  Alt({@required this.userUid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AlterProfile>(context,listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(
              userUid
            ).snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AlterProfile>(context,listen: false).headerProfile(context, snapshot, userUid),
                    Provider.of<AlterProfile>(context,listen: false).divider(),
                    Provider.of<AlterProfile>(context,listen: false).middleProfile(context, snapshot),
                    Provider.of<AlterProfile>(context,listen: false).footerProfile(context, snapshot,userUid)
                  ],
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: constantColors.blueGreyColor.withOpacity(0.6),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0))),
          
        ),
      ),
    );
  }
}
