import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resume_maker/presentation/home/home_controller.dart';
import 'package:resume_maker/presentation/widget/app_toast.dart';

import '../../core/utils/constant_sizebox.dart';

class AddResumeDetailsController extends GetxController {
  @override
  void onInit() {
    if (Get.arguments[0] != null) {
      data = Get.arguments[0];
      name.value.text = data.name!;
      email.value.text = data.email!;
      mobileNumber.value.text = data.mobileNumber!;
      address.value.text = data.address!;
      role.value.text = data.role!;
      summary.value.text = data.summary!;
    }
    isEdit = Get.arguments[1];
    update();
    super.onInit();
  }

  ResumeData data = ResumeData();
  bool isEdit = false;

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
                  child: Icon(Icons.camera),
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
                  child: Icon(Icons.photo_album),
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

    if (profileImage.value.path.isEmpty) {
      appToast(msg: "Select Profile");
      isValid.value = false;
    }

    if (name.value.text.isEmpty) {
      nameError.value = "Name field require";
      isValid.value = false;
    }

    if (email.value.text.isEmpty) {
      emailError.value = "Email field require";
      isValid.value = false;
    } else if (!email.value.text.isEmail) {
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
      }
    } else {
      return;
    }
  }

  onAdd() async {
    if (onvalid()) {
      isLoading.value = true;

      var id = FirebaseFirestore.instance.collection("resume").doc().id;

      Reference ref = FirebaseStorage.instance
          .ref()
          .child("images/${profileImage.value.path}");

      TaskSnapshot uploadTask = await ref.putFile(profileImage.value);

      String downloadURL = await uploadTask.ref.getDownloadURL();

      FirebaseFirestore.instance.collection("resume").doc(id).set({
        "profile_url": downloadURL,
        "name": name.value.text,
        "email": email.value.text,
        "mobile_number": mobileNumber.value.text,
        "role": role.value.text,
        "address": address.value.text,
        "summary": summary.value.text,
        "doc_id": id,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      }).then((value) {
        appToast(msg: "UPLOAD SUCCESSFULLY");
        Get.back();
        isLoading.value = false;
      });
    } else {}
  }

  onEdit() async {
    if (onvalid()) {
      isLoading.value = true;
      String downloadURL = "";
      if (profileImage.value.path.isNotEmpty &&
          profileImage.value.path.toString() != "null") {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child("images/${profileImage.value.path}");

        TaskSnapshot uploadTask = await ref.putFile(profileImage.value);

        downloadURL = await uploadTask.ref.getDownloadURL();
      }

      FirebaseFirestore.instance.collection("resume").doc(data.docId).update({
        "profile_url": downloadURL.isNotEmpty ? downloadURL : data.profileUrl,
        "name": name.value.text,
        "email": email.value.text,
        "mobile_number": mobileNumber.value.text,
        "role": role.value.text,
        "address": address.value.text,
        "summary": summary.value.text,
        "update_at": DateTime.now()
      }).then((value) {
        appToast(msg: "UPDATE SUCCESSFULLY");
        Get.back();
        isLoading.value = false;
      });
    } else {}
  }
}
