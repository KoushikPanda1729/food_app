import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  // Observable variable to store the restaurant parameter
  final Rx<String?> _currentRestaurant = Rx<String?>(null);

  // Getter for the restaurant parameter
  String? get currentRestaurant => _currentRestaurant.value;

  // Setter for the restaurant parameter
  set currentRestaurant(String? value) {
    _currentRestaurant.value = value;
    update(); // Notify listeners that the state has changed
    debugPrint("Restaurant parameter updated globally: $value");
  }

  // Method to update the restaurant parameter from URL parameters
  void updateRestaurantFromParameters() {
    String? restaurant = Get.parameters['restaurant'];
    if (restaurant != null) {
      currentRestaurant = restaurant;
    }
  }
}
