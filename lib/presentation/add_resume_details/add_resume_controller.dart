import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resume_maker/presentation/widget/app_toast.dart';

import '../../core/utils/constant_sizebox.dart';

class AddResumeDetailsController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<TextEditingController> name = TextEditingController(text: "").obs;
  Rx<TextEditingController> email = TextEditingController(text: "").obs;
  Rx<TextEditingController> mobileNumber = TextEditingController(text: "").obs;
  Rx<TextEditingController> address = TextEditingController(text: "").obs;
  Rx<TextEditingController> role = TextEditingController(text: "").obs;
  Rx<TextEditingController> summary = TextEditingController(text: "").obs;

  RxString nameError = "".obs;
  RxString emailError = "".obs;
  RxString mobileNumberError = "".obs;
  RxString addressError = "".obs;
  RxString roleError = "".obs;
  RxString summaryError = "".obs;

  Rx<File> profileImage = File("").obs;

  void pickProfileFile(context) async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              hSizedBox20,
              Text(
                "Selecet Image",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              hSizedBox20,
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.3,
                    ),
                  ),
                  // child: Image.asset(
                  //   ImageConstant.camera,
                  //   color: AppColors.appColor,
                  // ),
                ),
                title: Text(
                  "Take a photo",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Get.back();
                  await picImage(false);
                },
              ),
              hSizedBox10,
              Divider(
                thickness: 2,
                color: const Color(0xff707070).withOpacity(.3),
              ),
              hSizedBox10,
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.3,
                    ),
                  ),
                  // child: Image.asset(
                  //   ImageConstant.gallery,
                  //   color: AppColors.appColor,
                  // ),
                ),
                title: Text(
                  "Gallery",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Get.back();
                  await picImage(true);
                },
              ),
              hSizedBox20,
            ],
          ),
        );
      },
    );
  }

  bool onvalid() {
    RxBool isValid = true.obs;

    if (name.value.text.isEmpty) {
      nameError.value = "Name field require";
      isValid.value = false;
    }

    if (email.value.text.isEmpty) {
      emailError.value = "Email field require";
      isValid.value = false;
    } else if (!name.value.text.isEmail) {
      emailError.value = "Enter Valid Email";
      isValid.value = false;
    }

    if (mobileNumber.value.text.isEmpty) {
      mobileNumberError.value = "Mobile Number field require";
      isValid.value = false;
    } else if (mobileNumber.value.text.length != 10) {
      mobileNumberError.value = "Enter Valid Mobile Number";
      isValid.value = false;
    }

    if (address.value.text.isEmpty) {
      addressError.value = "Address field require";
      isValid.value = false;
    }

    if (role.value.text.isEmpty) {
      roleError.value = "Role field require";
      isValid.value = false;
    }

    if (summary.value.text.isEmpty) {
      summaryError.value = "Summary field require";
      isValid.value = false;
    }

    return isValid.value;
  }

  Future picImage(bool fromGallery) async {
    XFile? pickedFile;
    try {
      pickedFile = await ImagePicker().pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        maxHeight: 500,
        maxWidth: 500,
      );
    } catch (e) {
      log(e.toString());
    }
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
          compressQuality: 50,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "edit".tr,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: "edit".tr,
            ),
          ]);
      if (croppedFile != null) {
        profileImage.value = File(croppedFile.path);

        // print("===IMAGE SIZE==");
        // print(profileImage.value.readAsBytesSync().lengthInBytes);

        // multipartFile = dio.MultipartFile.fromFileSync(
        //   File(croppedFile.path).path,
        //   filename: path.basename(File(croppedFile.path).path),
        // );
        // edit();
      }
    } else {
      return;
    }
  }

  onAdd() {
    if (onvalid()) {
      isLoading.value = true;

      var id = FirebaseFirestore.instance.collection("resume").doc().id;

      FirebaseFirestore.instance.collection("resume").doc(id).set({
        "profile_url": "",
        "name": name.value.text,
        "email": email.value.text,
        "mobile_number": mobileNumber.value.text,
        "role": role.value.text,
        "address": address.value.text,
        "summary": summary.value.text,
        "doc_id": id,
      }).then((value) {
        appToast(msg: "UPLOAD SUCCESSFULLY");
        Get.back();
        isLoading.value = false;
      });
    } else {}
  }
}
