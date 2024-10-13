// this page was coded by Rayhan,
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// ^ for GridView.custom, gridDelegate properties, https://pub.dev/packages/flutter_staggered_grid_view
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social_app/data/model/user_data.dart';
import 'package:social_app/state_holders/profile_page_controller.dart';
import 'package:social_app/utility/app_colors.dart';
import 'package:social_app/utility/app_font_style.dart';
import 'package:social_app/utility/assets_path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.foregroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.secondaryColor
      // status bar color
    )
    );
  }
  final List<String> images = [
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://picsum.photos/200?random=1",
    "https://picsum.photos/200?random=2",
    "https://picsum.photos/200?random=3",
    "https://picsum.photos/200?random=4",
    "https://picsum.photos/200?random=5",
    "https://picsum.photos/200?random=6",
    "https://picsum.photos/200?random=7",
    "https://picsum.photos/200?random=8",
    "https://picsum.photos/200?random=9",
    "https://picsum.photos/200?random=10",
    "https://picsum.photos/200?random=11",
  ];
  UserData userData = UserData(
      name: "Mondol",
      userName: "@mondol123",
      numberOfPost: 5,
      following: 25,
      follower: 85
  );
  final controller = Get.put(ProfileScreenController());
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            profileHeaderSection(deviceSize, userData),
            const SizedBox(height: 8),
            Container(
              height: 0.7*deviceSize.height - 8,
              width: deviceSize.width-8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              //color: AppColors.foregroundColor,
              color: Colors.grey.shade200,
              child: GetBuilder<ProfileScreenController>(
                  builder: (profileScreenController) {
                    return Column(
                      children: [
                        gridOrListViewSelectorSection(deviceSize),
                        Visibility(
                          visible: profileScreenController.isGridViewSelected,
                          replacement: postListViewBuilder(images),
                          child: postGridViewBuilder(images),
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Expanded postListViewBuilder(List<String> images) {
    return Expanded(
      child: ListView.builder(
        primary: true,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(top: 10),
            child: Image.network(
                images[index],
                fit: BoxFit.cover),
          );
        },
        shrinkWrap: true,
      ),
    );
  }

  Expanded postGridViewBuilder(List<String> images) {
    return Expanded(
      child: GridView.custom(
        primary: true,
        shrinkWrap: true,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(1, 2),
            const QuiltedGridTile(1, 2),
            //QuiltedGridTile(1, 1),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          childCount: images.length,
              (context, index) => Card(
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          ),

        ),
      ),
    );
  }

  Column gridOrListViewSelectorSection(Size deviceSize) {
    return Column(
      children: [
        Stack(
          children: [
            GetBuilder<ProfileScreenController>(
                builder: (profileScreenController) {
                  return Row(
                    children: [
                      const Spacer(),
                      postListLayout(() {
                        profileScreenController.clickOnGridView();
                      }, "Grid View", AssetsPath.grid,
                          profileScreenController.isGridViewSelected),
                      const SizedBox(width: 16),
                      postListLayout(() {
                        profileScreenController.clickOnListView();
                      }, "List View", AssetsPath.list,
                          !profileScreenController.isGridViewSelected),
                      const Spacer()
                    ],
                  );
                }),
          ],
        )
      ],
    );
  }

  Widget postListLayout(
      dynamic onTap, String buttonName, String iconPath, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected? AppColors.secondaryColor
                  : Colors.transparent,
            ),
          ),
        ),
        child: Center(
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 16,
                ),
                const SizedBox(width: 2),
                Text(
                  buttonName,
                  style: AppFontStyle.satoshi500S12,
                ),
              ],
            )),
      ),
    );
  }

  Container profileHeaderSection(Size deviceSize, UserData userdata) {
    return Container(
      height: deviceSize.height / 3.8,
      color: AppColors.foregroundColor,
      padding: const EdgeInsets.all(10),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 38),
          const Text("My Profile", style: AppFontStyle.satoshi700S20),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://github.com/Rayhan-Sany/Rayhan-Sany/blob/main/Rayhan2-1-01-01-01-01-01.jpeg?raw=true"),
                minRadius: 40,
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userdata.name, style: AppFontStyle.satoshi700S18),
                  Text(
                    userdata.userName,
                    style: AppFontStyle.satoshi400S12
                        .copyWith(color: AppColors.textLightColor),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: [
                      Text(
                        "${userdata.numberOfPost}",
                        style: AppFontStyle.satoshi500S12,
                      ),
                      Text(
                        "Post",
                        style: AppFontStyle.satoshi400S12
                            .copyWith(color: AppColors.textLightColor),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${userdata.following}",
                        style: AppFontStyle.satoshi500S12,
                      ),
                      Text(
                        "Following",
                        style: AppFontStyle.satoshi400S12
                            .copyWith(color: AppColors.textLightColor),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${userdata.follower}",
                        style: AppFontStyle.satoshi500S12,
                      ),
                      Text(
                        "Follower",
                        style: AppFontStyle.satoshi400S12
                            .copyWith(color: AppColors.textLightColor),
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
