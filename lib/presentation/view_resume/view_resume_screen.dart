import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_maker/core/utils/app_image.dart';
import 'package:resume_maker/core/utils/constant_sizebox.dart';

import 'view_resume_controller.dart';

class ViewResumeScreen extends StatelessWidget {
  ViewResumeScreen({Key? key}) : super(key: key);

  final ViewResumeController _controller = Get.put(ViewResumeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Resume"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _controller.data.profileUrl!.isEmpty
                        ? AssetImage(AppImage.defaultImage)
                        : NetworkImage(_controller.data.profileUrl!)
                            as ImageProvider,
                  ),
                ),
              ),
            ),
            hSizedBox20,
            title("Name"),
            hSizedBox10,
            details(_controller.data.name!),
            hSizedBox20,
            title("Email"),
            hSizedBox10,
            details(_controller.data.email!),
            hSizedBox20,
            title("Mobile Number"),
            hSizedBox10,
            details(_controller.data.mobileNumber!),
            hSizedBox20,
            title("Adreess"),
            hSizedBox10,
            details(_controller.data.address!),
            hSizedBox20,
            title("Role"),
            hSizedBox10,
            details(_controller.data.role!),
            hSizedBox20,
            title("Summary"),
            hSizedBox10,
            details(_controller.data.summary!),
          ],
        ),
      ),
    );
  }

  Text details(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget title(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
