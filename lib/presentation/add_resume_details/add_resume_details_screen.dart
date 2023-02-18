import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resume_maker/core/utils/app_image.dart';
import 'package:resume_maker/core/utils/constant_sizebox.dart';
import 'package:resume_maker/presentation/widget/app_button.dart';
import 'package:resume_maker/presentation/widget/app_text_field.dart';

import 'add_resume_controller.dart';

class AddResumeDetailsScreen extends StatelessWidget {
  AddResumeDetailsScreen({Key? key}) : super(key: key);

  final AddResumeDetailsController _controller =
      Get.put(AddResumeDetailsController());

  @override
  Widget build(BuildContext context) {
    print(_controller.isEdit);
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume Details"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: title("Upload profile")),
            hSizedBox10,
            Center(
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    _controller.pickProfileFile(context);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _controller.isEdit == true &&
                                (_controller.profileImage.value.path.isEmpty ||
                                    _controller.profileImage.value.path
                                            .toString() ==
                                        "null")
                            ? NetworkImage(_controller.data.profileUrl ?? "")
                            : _controller.profileImage.value.path.isEmpty
                                ? AssetImage(AppImage.defaultImage)
                                : FileImage(_controller.profileImage.value)
                                    as ImageProvider,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            hSizedBox30,
            title("Name"),
            AppTextField(
              hintText: "Name",
              controller: _controller.name.value,
              errorMessage: _controller.nameError,
              onChange: (val) {
                _controller.nameError.value = "";
              },
            ),
            hSizedBox20,
            title("Email"),
            AppTextField(
              hintText: "Email",
              controller: _controller.email.value,
              errorMessage: _controller.emailError,
              onChange: (val) {
                _controller.emailError.value = "";
              },
            ),
            hSizedBox20,
            title("Mobile Number"),
            AppTextField(
              hintText: "Mobile Number",
              controller: _controller.mobileNumber.value,
              errorMessage: _controller.mobileNumberError,
              onChange: (val) {
                _controller.mobileNumberError.value = "";
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            hSizedBox20,
            title("Addess"),
            AppTextField(
              hintText: "Addess",
              controller: _controller.address.value,
              errorMessage: _controller.addressError,
              onChange: (val) {
                _controller.addressError.value = "";
              },
            ),
            hSizedBox20,
            title("Role"),
            AppTextField(
              hintText: "Role",
              controller: _controller.role.value,
              errorMessage: _controller.roleError,
              onChange: (val) {
                _controller.roleError.value = "";
              },
            ),
            hSizedBox20,
            title("Summary"),
            AppTextField(
              maxLines: 5,
              hintText: "Summary",
              controller: _controller.summary.value,
              errorMessage: _controller.summaryError,
              onChange: (val) {
                _controller.summaryError.value = "";
              },
            ),
            hSizedBox36,
            AppButton(
              text: _controller.isEdit == true ? "Update" : "Add",
              onPressed: () {
                _controller.isEdit == true
                    ? _controller.onEdit()
                    : _controller.onAdd();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ).paddingOnly(bottom: 10);
  }
}
