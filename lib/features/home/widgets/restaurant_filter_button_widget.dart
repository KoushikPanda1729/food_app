import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stackfood_multivendor/common/controllers/app_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class RestaurantsFilterButtonWidget extends StatelessWidget {
  const RestaurantsFilterButtonWidget(
      {super.key,
      required this.isSelected,
      this.onTap,
      required this.buttonText});

  final bool isSelected;
  final void Function(String? restaurant)? onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    String? restaurant = Get.find<AppController>().currentRestaurant;
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(restaurant);
        }
      },
      child: Container(
        height: 35,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                  : Theme.of(context).disabledColor.withValues(alpha: 0.3)),
        ),
        child: Center(
            child: Text(buttonText,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hintColor,
                ))),
      ),
    );
  }
}
