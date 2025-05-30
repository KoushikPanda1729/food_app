
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';

class StoreHelper {
  static bool inZone(Restaurant? restaurant) {
    if (restaurant == null) return false;
    String currentZoneId = Get.find<LocationController>().zoneID.toString();
    if (restaurant.zoneId.toString() == currentZoneId) {
      return true;
    }
    return false;
  }
}