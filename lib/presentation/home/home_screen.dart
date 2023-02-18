import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text("Resume Maker"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.addResumeDetails,
            arguments: [null, false],
          );
        },
        child: Icon(Icons.add),
      ),
      body: Obx(
        () => _controller.isLoading.value
            ? Center(child: CircularProgressIndicator.adaptive())
            : _controller.resumeList.isEmpty
                ? Center(child: Text("No data Found"))
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: _controller.resumeList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      var data = _controller.resumeList[index];
                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: data.profileUrl!.isEmpty
                                          ? AssetImage(AppImage.defaultImage)
                                          : NetworkImage(data.profileUrl!)
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                                wSizedBox10,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.name!),
                                    Text(data.email!),
                                    Text(data.createAt.toString()),
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
                                  color: Colors.blue,
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.addResumeDetails,
                                      arguments: [
                                        _controller.resumeList[index],
                                        true
                                      ],
                                    );
                                  },
                                ),
                                wSizedBox10,
                                actionButton(
                                  icon: Icons.visibility,
                                  title: "View",
                                  color: Colors.green,
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.viewResume,
                                      arguments: _controller.resumeList[index],
                                    );
                                  },
                                ),
                                wSizedBox10,
                                actionButton(
                                  icon: Icons.delete,
                                  title: "Delete",
                                  color: Colors.red,
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Alert'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'Are you sure you want to delete?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Yes'),
                                              onPressed: () {
                                                Get.back();

                                                FirebaseFirestore.instance
                                                    .collection("resume")
                                                    .doc(data.docId)
                                                    .delete();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // FirebaseFirestore.instance
                                    //     .collection("resume")
                                    //     .doc(data.docId)
                                    //     .delete();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  InkWell actionButton({
    required String title,
    required IconData icon,
    required Function() onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              wSizedBox10,
              Icon(icon, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
