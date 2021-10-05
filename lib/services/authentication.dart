import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Authentication with  ChangeNotifier{
final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
final GoogleSignIn googleSignIn=GoogleSignIn();

String userUid;
String get getUserUid=>userUid;
Future loginToAcconut(String email,String password)async{
  UserCredential userCredential=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  User user=userCredential.user;
  userUid=user.uid;
  print(userUid);
  notifyListeners();

}
Future createAcconut(String email,String password)async{
  UserCredential userCredential=await firebaseAuth.createUserWithEmailAndPassword(email:email, password: password);
  User user=userCredential.user;
  userUid=user.uid;
  print('create User Uid => $userUid');
  print(userUid);
  notifyListeners();

}
Future signoutWithAccount()async{
  return firebaseAuth.signOut();
}
Future signinWithGoogle()async{
  final GoogleSignInAccount googleSignInAccount= await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
  final AuthCredential authCredential=GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken

  );
  final UserCredential userCredential=await firebaseAuth.signInWithCredential(authCredential);
  final User user=userCredential.user;
  assert(user.uid !=null);
  userUid=user.uid;
  print('Google User Uid => $userUid');

}
Future signoutWithGoogle()async{
  return googleSignIn.signOut();
}
/*
Future signinwithfacebook()async{

  FacebookLoginResult result=await facebookLogin.logIn(['email']);
  final acessTokn=result.accessToken.token;
  if(result.status==FacebookLoginStatus.loggedIn){
    final facecredentaial=FacebookAuthProvider.credential(acessTokn);

    //final UserCredential userCredential=
    await firebaseAuth.signInWithCredential(facecredentaial);
   */
/* final User user=userCredential.user;
    assert(user.uid !=null);
    userUid=user.uid;
    print('Google User Uid => $userUid');*//*

  }

*/

}
