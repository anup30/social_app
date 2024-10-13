import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Data/image_data.dart';
import 'package:social_app/components/my_text_field.dart';
import 'package:social_app/social_app.dart';


class HomePageController extends GetxController{
  final TextEditingController descriptionController = TextEditingController(); // dispose ? -----
  final User? user = FirebaseAuth.instance.currentUser;
  String? uid;
  String? email;
  String? displayName;
  String? profilePicUrl;
  List<ImageData> imageDataList =[];
  String? picUrl;
  HomePageController(){
    if(user != null){
      uid = user?.uid;
      email =  user?.email;
      displayName = user?.displayName;
      profilePicUrl = user?.displayName;
      update();
    }
  }

  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage='';
  String get errorMessage => _errorMessage?? "";
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Stream<QuerySnapshot> getDataStream() {  // async*
    return _firebaseFirestore.collection('allUploadInfo').snapshots(); // yield, return
  }

  void uploadImage(BuildContext context)async{
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: const Text('Upload Photo from :'),
          elevation: 10,
          children: [
            SimpleDialogOption(
              onPressed: () {
                pickGalleryImage();
                Navigator.pop(context);
              },
              child: const Text('Gallery Image'),
            ),
            SimpleDialogOption(
              onPressed: () {
                pickCameraImage();
                Navigator.pop(context);
              },
              child: const Text('Camera Image'),
            ),
          ],
        );
      },
    );
  }
  void pickGalleryImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      uploadToFirebaseStorage(File(pickedFile.path));
    }
    else{
      print("error: pickedFile==null");
    }
  }
  void pickCameraImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.camera);
    if(pickedFile!=null){
      uploadToFirebaseStorage(File(pickedFile.path));
    }
    else{
      print("error: pickedFile==null");
    }
  }
  Future<void> uploadToFirebaseStorage(File image) async{
    if(user==null) return;
    _inProgress =true;
    update();
    Reference storageRef = FirebaseStorage.instance.ref().child("/uploads");
    Reference sr = storageRef.child("/${DateTime.now().millisecondsSinceEpoch}.png");
    String? imageDescription = await postDescription(image);
    if(imageDescription==null){
      _inProgress =false;
      update();
      return; // don't upload
    }
    try {
      if(email==null){throw "error: user not logged in";}
      await sr.putFile(image);
      picUrl = await sr.getDownloadURL();
      List<String> dateTime = DateTime.now().toUtc().toString().split('.'); // format: 2024-09-11 18:23:58 // Coordinated Universal Time
      if(picUrl==null){throw "error: picture url is null";}
      Map<String, String> picInfo = {
        'description' : imageDescription, // alternatively customMetadata in SettableMetadata
        'picUrl' : picUrl??"", // firebase storage link, if null don't upload
        'dateTime' : "${dateTime[0]} Utc",
        'uploaderEmail' : email??"", // if null don't upload
        'uploaderHandle': displayName??"",
        'uploaderUid': uid??"",
      };
      _firebaseFirestore.collection('allUploadInfo').doc().set(picInfo); //-----
    } catch (e) {
      Get.snackbar( // <-----
        'Error', // title
        e.toString(), // message
        snackPosition: SnackPosition.BOTTOM, // position of the snackbar
        backgroundColor: Colors.black54, // background color
        colorText: Colors.white, // text color
        borderRadius: 10, // border radius
        margin: const EdgeInsets.all(10), // margin around the snackbar
        duration: const Duration(seconds: 5), // how long the snackbar should be visible
      );
      log("error occurred: $e");
    }
    _inProgress=false;
    update();
  }
  Future<String?> postDescription(File image)async{
    String? s1;
    String? s = await showModalBottomSheet<String?>( // showBottomSheet vs showModalBottomSheet
      context: SocialApp.navigatorKey.currentContext!,
      builder: (context){
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column( // or ListView ?
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.file(image, fit: BoxFit.contain),
                ),
                const SizedBox(height: 8),
                MyTextField(
                  controller: descriptionController,
                  //label: 'Add Description',
                  hintText: 'Short description about the photo',
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        s1 = descriptionController.text;
                        Navigator.pop(context, s1);
                      },
                      child: const Text("Upload"),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context, s1);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
    return s;
  }
}