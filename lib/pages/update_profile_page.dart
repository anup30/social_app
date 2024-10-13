// profile pic updated by camera image, but problem with gallery image.
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/pages/home_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; ///
  final User? user = FirebaseAuth.instance.currentUser; ///
  final displayNameController = TextEditingController();
  String? profilePicUrl;
  String? uid;
  String? displayName;
  String? email;

  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading=false;

  @override
  void initState() {
    super.initState();
    if(user != null){
      uid = user!.uid;
      displayName = user!.displayName;
      email = user!.email;
      profilePicUrl = user!.photoURL;
    }
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_isLoading) const CircularProgressIndicator(),
            // ElevatedButton(
            //   onPressed: ()async{
            //     Map<String, dynamic> data ={
            //       "SetOptions": "test 2",
            //       "abc":"def",
            //       "xyx":"mno",
            //     };
            //     await _firebaseFirestore.collection('test3').doc("abc").set(data); // update requires .doc(uid) ---------------//////////////////////////////////
            //     //await _firebaseFirestore.collection('test1').doc(uid).set(data, SetOptions(merge: true)); // test a doc to collection ----------------------
            //   },
            //   child: const Text("test update"),
            // ),
            //if(displayName==null)...[displayNameUpdateWidget()],
            //if(profilePicUrl==null)...[profilePicUpdateWidget()],
            const SizedBox(height: 8),
            displayNameUpdateWidget(),
            const SizedBox(height: 8),
            profilePicUpdateWidget(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: (){
                if(user!.displayName != null && user!.photoURL != null){
                  Get.to(()=>const HomePage());
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🔥 please update display name and profile picture"),
                      duration: Duration(seconds: 5),
                    ),
                  );
                  print("please update display name and profile picture");
                }
              },
              child: const Text('go Home Screen'),
            ),
            ElevatedButton(
                onPressed: (){
                  print("display name: ${user!.displayName}");
                  print("photo url: ${user!.photoURL}");
                },
                child: const Text("print info")),
          ],
        ),
      ),
    );
  }
  Widget displayNameUpdateWidget(){
    return Column(
      children: [
        const Text(
          "Type a Display Name (handle) for you",
          style: TextStyle(fontSize: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              labelText: 'display name',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.green),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:  ()async{
            if(displayNameController.text.isNotEmpty){
              await user?.updateDisplayName(displayNameController.text);
              Map<String, dynamic> handle ={
                'email' : email,
                "handle": displayNameController.text,
                'uid' : uid,
              };
              //merge new data // https://firebase.google.com/docs/firestore/manage-data/add-data
              await _firebaseFirestore.collection('users').doc(uid).set(handle, SetOptions(merge: true)); // or update ?
              displayName = displayNameController.text;
              setState(() {});
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🔥error: Handle is empty or null"),
                  duration: Duration(seconds: 5),
                ),
              );
              print('Handle is empty or null');
            }
          },
          child: const Text("Upload display name"),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
  Widget profilePicUpdateWidget(){
    return Column(
      children: [
        const Text(
          "Select a Profile Picture :",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (_) {
                return SimpleDialog(
                  title: const Text('Choose Option'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera, size: 40),
                          onPressed: () async {
                            try{
                              _isLoading = true;
                              setState(() {});
                              XFile? pickedFile = await _imagePicker
                                  .pickImage(source: ImageSource.camera);
                              if (pickedFile != null) {
                                final image = File(pickedFile.path);
                                if (uid == null) {
                                  throw "error: uid is null";
                                }
                                Reference storageRef = FirebaseStorage.instance.ref();
                                Reference sr = storageRef.child("/profilePics").child("/$uid.png");
                                await sr.putFile(image);
                                profilePicUrl = await sr.getDownloadURL();
                                await user?.updatePhotoURL(profilePicUrl);
                                _isLoading=false;
                                setState(() {});
                                if(mounted){
                                  Navigator.pop(context); // pop SimpleDialog
                                }
                                //Get.to(()=> const HomePage());
                              }
                            }catch(e){
                              if(mounted){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("🔥${e.toString()}"),
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                              log(e.toString());
                            }
                          },
                        ),
                        const Divider(),
                        IconButton(
                          icon: const Icon(Icons.image_rounded, size: 40),
                          onPressed: () async {
                            try{
                              _isLoading = true;
                              setState(() {});
                              XFile? pickedFile = await _imagePicker
                                  .pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                final image = File(pickedFile.path);
                                Reference storageRef =
                                FirebaseStorage.instance.ref().child("/profilePics");
                                if (uid == null) {
                                  throw "error: uid is null";
                                }
                                Reference sr = storageRef.child("/$uid.png");
                                await sr.putFile(image);
                                profilePicUrl = await sr.getDownloadURL();
                                await user?.updatePhotoURL(profilePicUrl); // added
                                _isLoading=false;
                                setState(() {});
                                if(mounted){
                                  Navigator.pop(context); // pop SimpleDialog
                                }
                              }else{
                                log("error: pickedFile == null");
                              }
                            }catch(e){
                              if(mounted){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("🔥${e.toString()}"),
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                              log("error: ${e.toString()}");
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('select picture'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
