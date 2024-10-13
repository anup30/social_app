import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/update_profile_page.dart';
import 'package:social_app/state_holders/home_page_controller.dart';

class AppBarAvatar extends StatelessWidget {
  final HomePageController controller = Get.find();
  late final String? uid;
  late final String? displayName;
  late final String? email;
  late final String? profilePicUrl;

  AppBarAvatar({super.key}){
    uid = controller.uid;
    displayName = controller.displayName;
    email = controller.email;
    profilePicUrl = controller.profilePicUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> showDialog(
        context: context,
        barrierDismissible : false, // default: true,
        builder: (BuildContext context) {
          return AlertDialog( // <--------------------
            title: const Text('Account Info'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('your uid: $uid'),
                Text('your handle name: $displayName'),
                Text('your email: $email'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: (){
                    Get.to(()=>const ProfilePage());
                  },
                  child: const Text('go Profile screen ->'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: (){
                    Get.to(()=>const UpdateProfilePage());
                  },
                  child: const Text('go Update Profile screen ->'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {Navigator.pop(context);},
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(profilePicUrl??""), // check FadeInImage.assetNetwork()
        backgroundColor: Colors.transparent,
        // child: ClipOval(
        //   child: FadeInImage.assetNetwork(
        //       placeholder: "assets/images/profile.png",
        //       image: profilePicUrl??"",
        //   ),
        // ),
      ),
    );
  }
}