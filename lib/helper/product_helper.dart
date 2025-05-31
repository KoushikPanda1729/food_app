import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';

class ProductHelper {
  static bool isAvailable(Product product) {
    return DateConverter.isAvailable(
        product.availableTimeStarts, product.availableTimeEnds);
  }

  static double? getDiscount(Product product) => product.restaurantDiscount == 0
      ? product.discount
      : product.restaurantDiscount;

  static String? getDiscountType(Product product) =>
      product.restaurantDiscount == 0 ? product.discountType : 'percent';

  static bool inZone(Product? product) {
    if (product == null) return false;
    String currentZoneId = Get.find<LocationController>().zoneID.toString();
    if (product.zoneId == currentZoneId) {
      return true;
    }
    return false;
  }
}
