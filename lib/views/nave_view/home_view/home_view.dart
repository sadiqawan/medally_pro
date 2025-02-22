import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import '../../../const/contant_style.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPriemryColor,
        title: Row(
          children: [
            userImage(),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome To 👋",
                    style: kSubTitle2B.copyWith(fontSize: 16.sp)),
                Text(
                  "QurbaniApp",
                  style: kSubTitle2B.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        items: homeController.itemsActionBar,
        color: kPriemryColor,
        icon: Icons.add,
        duration: const Duration(milliseconds: 200),
        curveAnim: Curves.ease,
        useOpacity: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

Widget userImage() {
  HomeController controller = Get.put(HomeController());
  return StreamBuilder(
      stream: controller.getCurrentUserDataStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        }
        var userData = snapshot.data?.data();
        if (userData == null || userData['picture'] == null) {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        } else {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundImage: NetworkImage(userData!['picture']),
          );
        }
      });
}
