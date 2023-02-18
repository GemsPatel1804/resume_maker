import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getAllResume();
    super.onInit();
  }

  RxInt index = 0.obs;

  RxBool isLoading = false.obs;

  RxList<ResumeData> resumeList = RxList([]);

  getAllResume() async {
    try {
      isLoading.value = true;
      var data = FirebaseFirestore.instance.collection("resume").snapshots();

      await data.forEach((element) {
        resumeList.clear();
        element.docs.asMap().forEach((index, data) {
          return resumeList.add(ResumeData(
            address: data["address"],
            createAt:
                DateFormat("dd/MM/yyyy").format(data["create_at"].toDate()),
            docId: data["doc_id"],
            email: data["email"],
            mobileNumber: data["mobile_number"],
            name: data["name"],
            profileUrl: data["profile_url"],
            role: data["role"],
            summary: data["summary"],
          ));
        });
        isLoading.value = false;
      });

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }
}

class ResumeData {
  String? address,
      docId,
      email,
      mobileNumber,
      name,
      summary,
      profileUrl,
      role,
      createAt;

  ResumeData({
    this.address,
    this.createAt,
    this.docId,
    this.email,
    this.mobileNumber,
    this.name,
    this.profileUrl,
    this.role,
    this.summary,
  });
}
