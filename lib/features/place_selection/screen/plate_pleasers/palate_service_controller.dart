import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';

class PalateServiceController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? countryDialCode = CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel!.country!)
      .dialCode;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  String selectedOutlet = 'Wedding Catering';
  DateTime selectedDate = DateTime.now();

  final List<String> outlets = [
    'Wedding Catering',
    'Social Catering',
    'Corporate Catering',
    'Banquet Booking',
  ];

  void loadUserInfo() {
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<ProfileController>().userInfoModel != null) {
      final userInfo = Get.find<ProfileController>().userInfoModel;
      nameController.text = userInfo?.fName ?? '';
      phoneController.text = '';
      emailController.text = userInfo?.email ?? '';
      messageController.text = '';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  bool isFormValid() {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    return name.isNotEmpty && phone.isNotEmpty && phone.length == 10;
  }

  void showNotificationCard(BuildContext context, bool isSuccess) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => buildNotificationCard(context, isSuccess, () {
        overlayEntry.remove();
      }),
    );

    overlayState.insert(overlayEntry);
  }

  Future<void> submitReservation(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;

        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

        Map<String, dynamic> payload = {
          "service": selectedOutlet,
          "name": nameController.text,
          "phone": phoneController.text,
          "email": emailController.text.isNotEmpty ? emailController.text : '',
          "date": formattedDate,
          "message":
              messageController.text.isNotEmpty ? messageController.text : '',
        };
        final response = await http.post(
          Uri.parse('https://order.shanghai.net.in/palate_pleasers_book.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        showNotificationCard(context, response.statusCode == 200);
      } catch (e) {
        showNotificationCard(context, false);
      } finally {
        isLoading = false;
        selectedOutlet = 'Wedding Catering';
        selectedDate = DateTime.now();
        messageController.clear();
      }
    }
  }

  Widget buildNotificationCard(
      BuildContext context, bool isSuccess, VoidCallback onClose) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? 'Reservation Successful' : 'Reservation Failed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isSuccess
                      ? 'Your table has been successfully reserved'
                      : 'Unable to complete your reservation. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    // Close the overlay
                    onClose();

                    // If success, navigate to home, otherwise just close the notification
                    if (isSuccess) {
                      Get.toNamed(RouteHelper.placeSelection);
                    }
                    // For failure, we just close the overlay and let them try again
                  },
                  child: Text(
                    isSuccess ? 'Go to Home' : 'Try Again',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
