import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_maker/core/utils/app_image.dart';
import 'package:resume_maker/core/utils/constant_sizebox.dart';
import 'package:resume_maker/routes/app_routes.dart';

import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume Maker"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(AppImage.defaultImage),
                        ),
                      ),
                    ),
                    wSizedBox10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gautam Davara"),
                        Text("gems4860@gmail.com"),
                        Text(DateTime.now().toString()),
                      ],
                    )
                  ],
                ),
                hSizedBox10,
                Row(
                  children: [
                    actionButton(
                      icon: Icons.edit,
                      title: "Edit",
                      onTap: () {
                        Get.toNamed(AppRoutes.addResumeDetails);
                      },
                    ),
                    wSizedBox10,
                    actionButton(
                      icon: Icons.visibility,
                      title: "View",
                      onTap: () {
                        Get.toNamed(AppRoutes.viewResume);
                      },
                    ),
                    wSizedBox10,
                    actionButton(
                      icon: Icons.delete,
                      title: "Delete",
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell actionButton({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Text(title),
              wSizedBox10,
              Icon(
                icon,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
