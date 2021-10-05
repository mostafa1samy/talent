import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Chatroom/chathelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(FontAwesomeIcons.plus,color: constantColors.greenColor,), onPressed: (){
            Provider.of<ChatHlper>(context,listen: false).showcreateclassroomchat(context);
      }),

      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(EvaIcons.moreVertical,color: constantColors.whiteColor,), onPressed: (){})
        ],
        leading: IconButton(icon: Icon(FontAwesomeIcons.plus,color: constantColors.greenColor,), onPressed: (){
          Provider.of<ChatHlper>(context,listen: false).showcreateclassroomchat(context);
        }),
        title: RichText(
          text: TextSpan(
              text: 'Chat',
              style:
                  TextStyle(color: constantColors.whiteColor, fontSize: 20.0),
              children: <TextSpan>[
                TextSpan(
                    text: 'Box',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold))
              ]),
        ),
      ),
      body: Container(height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
      child: Provider.of<ChatHlper>(context,listen: false).shochatrooms(context),),
    );
  }
}
