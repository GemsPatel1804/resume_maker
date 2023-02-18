import 'package:get/get.dart';

import '../presentation/add_resume_details/add_resume_details_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/view_resume/view_resume_screen.dart';

class AppRoutes {
  static String home = '/home';
  static String addResumeDetails = '/addResumeDetails';
  static String viewResume = '/viewResume';

  static List<GetPage> pages = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: addResumeDetails, page: () => AddResumeDetailsScreen()),
    GetPage(name: viewResume, page: () => ViewResumeScreen()),
  ];
}
