// problem: not being able to upload picture, after selecting picture, description writing isn't coming.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social_app/components/my_drawer.dart';
import 'package:social_app/data/image_data.dart';
import 'package:social_app/state_holders/home_page_controller.dart';
import 'package:social_app/utility/assets_path.dart';
import 'package:social_app/components/appBar_avatar.dart';
import 'package:social_app/components/app_logo.dart';
import 'package:social_app/components/posts_gridview.dart';
import 'package:social_app/components/posts_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController _controller = Get.put(HomePageController());
  final TextEditingController descriptionController = TextEditingController();
  List<ImageData> imageDataList =[];
  final User? user = FirebaseAuth.instance.currentUser; ///
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userInfo();
    });
  }
  Future<void>userInfo()async{
    if (user != null) {
      _controller.uid = user!.uid; // ok
      for (final providerProfile in user!.providerData) {
        _controller.displayName = providerProfile.displayName; // null, set: https://firebase.google.com/docs/auth/flutter/manage-users
        _controller.email= providerProfile.email;
        _controller.profilePicUrl = providerProfile.photoURL; // null
      }
      setState(() {});
      // if(_controller.displayName==null || _controller.profilePicUrl==null){ -------------------------------
      //   Get.off(()=> const UpdateProfilePage()); // Navigator.pushReplacement()
      // }
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AppBarAvatar(),
          ),
          title: const Center(child: AppLogo()),
          /*
          actions: [
            InkWell(
              onTap: (){
                // do latter ---
              },
              child: CircleAvatar(
                child: SvgPicture.asset(
                    AssetsPath.notification,
                  //color: Colors.white, // deprecated
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.inversePrimary, BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: (){
                Get.to(()=> const UpdateProfilePage());
              },
              child: CircleAvatar(
                child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: (){
                Get.to(()=> const ChatPage());
              },
              child: CircleAvatar(
                child: SvgPicture.asset(
                  AssetsPath.message,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.inversePrimary, BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              child: IconButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  //Get.offAll(() => const LandingScreen());
                },
                icon: SvgPicture.asset(
                  AssetsPath.logout,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.inversePrimary, BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          */
        ),
        endDrawer: const MyDrawer(), // drawer vs endDrawer // disable actions in AppBar to show endDrawer
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _controller.inProgress ?
          const Center(child: CircularProgressIndicator()) : Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // ElevatedButton(
              //   onPressed: (){
              //     _controller.uploadImage(context); // upload to firebase
              //   },
              //   child: const Text('share a photo'),
              // ),
              // const SizedBox(height: 8),
              // vertical ListView/GridView all posts
              // -> by which user, picture, comments
              TabBar( // -----
                dividerColor: Colors.blue.shade100,
                //dividerHeight: 40, ///
                tabs: [
                  const Tab(icon: Icon(Icons.list), text: 'ListView',), // Tabs are horizontally scrollable
                  //Tab(icon: Icon(Icons.grid_3x3), text: 'GridView',),
                  Tab(icon: SvgPicture.asset(AssetsPath.grid), text: 'GridView',),
                ],
              ),
              buildPostsView(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.uploadImage(context);
          },
          child: const Icon(Icons.add),
        ),
        //bottomNavigationBar: ,
      ),
    );
  }

  Widget buildPostsView() {
    return Expanded( // Flexible, Expanded: conflict with SingleChildScrollView
      child: StreamBuilder<QuerySnapshot>(
        stream: _controller.getDataStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          imageDataList.clear();
          for (QueryDocumentSnapshot doc in (snapshot.data?.docs ?? [])) { // or var doc,
            imageDataList.add(
                ImageData.fromJson(doc.id, doc.data() as Map<String, dynamic>));
          }
          imageDataList.sort((a, b) =>
              b.dateTime!.compareTo(a.dateTime!)); // recent uploads on top.
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                PostsListView(imageDataList: imageDataList),
                PostsGridView(imageDataList: imageDataList),
              ],
            ),
          );
        },
      ),
    );
  }
}
