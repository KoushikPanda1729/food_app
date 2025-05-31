// lib/helper/initial_binding.dart
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/controllers/app_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(),
        permanent: true); // ✅ Ensures availability before any widget
  }
}
