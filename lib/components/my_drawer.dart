import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/pages/update_profile_page.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:social_app/state_holders/theme_controller.dart';
import 'package:social_app/utility/assets_path.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(){
    final auth = AuthService();
    auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo
          const DrawerHeader(
              child: Center(
                child: Icon(
                  Icons.message,
                  //color: Theme.of(context).colorScheme.primary, --------------------
                  //color: Colors.amber,
                  size: 40,
                ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => themeController.isDarkMode.value
                    ? const Text("Dark Mode")
                    : const Text("Light Mode")
                ),
                Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value)=> themeController.toggleTheme(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("C H A T"),
              leading: const Icon(Icons.home),
              onTap: (){
                Navigator.pop(context); // pop drawer
                Get.to(()=> const ChatPage());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("UpdateProfile"),
              leading: const Icon(Icons.edit),
              onTap: (){
                Navigator.pop(context); // pop drawer
                Get.to(()=> const UpdateProfilePage());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("C H A T"),
              leading: SvgPicture.asset(
                AssetsPath.message,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.inversePrimary, BlendMode.srcIn,
                ),
              ),
              onTap: (){
                Navigator.pop(context); // pop drawer
                Get.to(()=> const ChatPage()); // if drawer in homepage, homepage is also popped !
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 25),
          //   child: ListTile(
          //     title: const Text("Notifications"),
          //     leading: SvgPicture.asset(
          //       AssetsPath.notification,
          //       colorFilter: ColorFilter.mode(
          //         Theme.of(context).colorScheme.inversePrimary, BlendMode.srcIn,
          //       ),
          //     ),
          //     onTap: (){
          //       Navigator.pop(context); // pop drawer
          //       Get.to(()=> const ChatPage());
          //     },
          //   ),
          // ),
          // logout list tile
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              //onTap: logout,
              onTap: ()=> FirebaseAuth.instance.signOut(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text("Exit App"),
              leading: const Icon(Icons.close),
              onTap: ()=> SystemNavigator.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
