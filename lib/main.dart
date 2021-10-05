import 'package:fcitalent/screens/Alt/altProfile.dart';
import 'package:fcitalent/screens/Chatroom/chathelper.dart';
import 'package:fcitalent/screens/Feed/Feedhelpers.dart';
import 'package:fcitalent/screens/HomePage/Homepagehelper.dart';
import 'package:fcitalent/screens/Laoding/Loadingservices.dart';
import 'package:fcitalent/screens/Laoding/Loadingutils.dart';
import 'package:fcitalent/screens/Profile/Profilehlpers.dart';
import 'package:fcitalent/screens/message/groupmessahehelper.dart';
import 'package:fcitalent/screens/stories/stories_helper.dart';
import 'package:fcitalent/services/Firebaseoperation.dart';
import 'package:fcitalent/services/authentication.dart';
import 'package:fcitalent/utils/Postoption.dart';
import 'package:fcitalent/utils/Uploadpost.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fcitalent/conatants/Constantcolors.dart';
import 'package:fcitalent/screens/Laoding/LoadingHlper.dart';
import 'package:fcitalent/screens/SplahScreen/splashScreen.dart';
import 'package:provider/provider.dart';



import 'conatants/Constantcolors.dart';
import 'screens/SplahScreen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=new ConstantColors();
    return MultiProvider(
        child:  MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: 'Poppins',
              canvasColor: constantColors.transperant

          ),
        ),
        providers: [ ChangeNotifierProvider(create: (_)=>LoadingHlpers()),
          ChangeNotifierProvider(create: (_)=>Authentication()),
          ChangeNotifierProvider(create: (_)=>PostOption()),
          ChangeNotifierProvider(create: (_)=>UploadPost()),
          ChangeNotifierProvider(create: (_)=>FeedHelper()),
          ChangeNotifierProvider(create: (_)=>LoadingServices()),
          ChangeNotifierProvider(create: (_)=>FirebaseOperation()),
          ChangeNotifierProvider(create: (_)=>HomeHlper()),
          ChangeNotifierProvider(create: (_)=>ProfileHelper()),
          ChangeNotifierProvider(create: (_)=>ChatHlper()),
          ChangeNotifierProvider(create: (_)=>AlterProfile()),
          ChangeNotifierProvider(create: (_)=>GroupingMessagingHelper()),
          ChangeNotifierProvider(create: (_)=>StoriesHelper()),
          ChangeNotifierProvider(create: (_)=>LoadingUtils(),
          )
        ]);
  }
}




