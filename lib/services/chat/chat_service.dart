import 'dart:developer';

import 'package:social_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get user stream
  /*
    List<Map<String, dynamic> =
    [
      {
        'email' : test@gmail.com,
        'id' : ..
      },
      {
        'email' : mitch@gmail.com,
        'id' : ..
      },
    ]
  */
  Stream<List<Map<String, dynamic>>> getUsersStream(){ // not being able to wrap in try catch
    return _firestore.collection("users").snapshots().map( // users vs Users --------
      //(snapshot){
            (snapshot) =>
            snapshot.docs.map(
                    (doc){
                  // go through each individual user
                  final user = doc.data();
                  //log("${user.runtimeType}"); // _Map<String, dynamic>
                  user.forEach((key,value)=> print('$key : $value'));
                  //log(user as String); // no print
                  return user;
                }).toList());
    //});
  }
  // send message
  Future<void> sendMessage(String receiverId, message)async{
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail= _auth.currentUser!.email??"";
    final Timestamp timestamp = Timestamp.now(); // package:cloud_firestore_platform_interface/ src/ timestamp. dart
    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
    );
    // construct chat room id for the 2 users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    // ad new message to database
    await _firestore.collection("chat_rooms").doc(chatRoomId)
        .collection("messages").add(newMessage.toMap());


  }
  // get message
  Stream<QuerySnapshot> getMessages(String userId, otherUserId){
    // construct chat room id for the 2 users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore.collection("chat_rooms").doc(chatRoomId).collection("messages")
        .orderBy("timestamp", descending: false).snapshots();

  }
}