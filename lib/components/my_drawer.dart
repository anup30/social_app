
import 'package:get/get.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/pages/settings_page.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void logout(){
      final auth = AuthService();
      auth.signOut();
    }
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
                  color: Colors.amber,
                  size: 40,
                ),
              ),
          ),
          // home list tile
          Padding(
              padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: (){
                Navigator.pop(context); // pop drawer
                Get.off(()=> const HomePage());
              },
            ),
          ),
          // settings list tile
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: (){
                Navigator.pop(context); // pop drawer
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingsPage(),
                ));
              },
            ),
          ),
          // logout list tile
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
