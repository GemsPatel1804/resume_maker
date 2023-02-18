import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_resume_controller.dart';

class ViewResumeScreen extends StatelessWidget {
  ViewResumeScreen({Key? key}) : super(key: key);

  final ViewResumeController _controller = Get.put(ViewResumeController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
