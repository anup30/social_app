import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/components/show_alert_dialog.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? getCurrentUser(){
    return _auth.currentUser;
  }
  Future<void> signInWithEmailPassword(String email, password, BuildContext context) async{
    try{
      // sign user in
      UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      //return uc;
    }on FirebaseAuthException catch (e){
      //throw Exception(e.code);
      if(context.mounted){
        showAlertDialog(
          context: context,
          title: "Error occurred!",
          content: "couldn't sign in! error code: ${e.code}",
        );
      }
    }
    catch(e){
      print(e.toString());
      //throw Exception(e.toString()); // use if error handling is implemented in caller.
      if(context.mounted){
        showAlertDialog(
          context: context,
          title: "Error occurred!",
          content: "couldn't sign in! error code: ${e.toString()}",
        );
      }
    }
  }
  Future<void> signOut()async{
    return await _auth.signOut();
  }
  Future<void> signUpWithEmailPassword(String email, String password, BuildContext context) async{ // Future<void> ---
    try{ 
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      // save user info in a separate doc
      await _firestore.collection("users").doc(uc.user!.uid).set(
        {
          'uid': uc.user!.uid,
          'email': email,
        }
      );
      //return uc;
    }on FirebaseAuthException catch (e){
      // throw Exception(e.code);
      // https://firebase.google.com/docs/auth/flutter/password-auth
      if(context.mounted){
        showAlertDialog(
          context: context,
          title: "Error occurred!",
          content: "couldn't sign up! error code: ${e.code}",
        );
      }
    }
    catch(e){
      print(e.toString());
      //throw Exception(e.toString()); // use if error handling is implemented in caller.
      if(context.mounted){
        showAlertDialog(
          context: context,
          title: "Error occurred!",
          content: "couldn't sign up! error code: ${e.toString()}",
        );
      }
      // return uc; // doesn't get here
    }
  }
}