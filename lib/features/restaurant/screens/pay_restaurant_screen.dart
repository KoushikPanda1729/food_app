import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/payment_method_bottom_sheet2.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart' show RestaurantController;
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart' show AppConstants;
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:universal_html/html.dart' as html;

class PayRestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  const PayRestaurantScreen({super.key, required this.restaurant});

  @override
  State<PayRestaurantScreen> createState() => _PayRestaurantScreenState();
}

class _PayRestaurantScreenState extends State<PayRestaurantScreen> {
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  double walletBalance = 0;
  double total = 0;
  double discountPercent = 0;


  @override
  void initState() {
    super.initState();
    initCallData();
  }

  void initCallData() {
    Get.find<CheckoutController>().setPaymentMethod(-1, willUpdate: false);
    Get.find<CheckoutController>().resetPartialPayment();
    walletBalance = Get.find<ProfileController>().userInfoModel?.walletBalance ?? 0;
    discountPercent = Get.find<SplashController>().configModel?.shanghaiDiscount ?? 0;
  }

  void applyDiscount() {
    total = total - (total * discountPercent / 100);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'pay_restaurant'.tr),
      body: Get.find<AuthController>().isLoggedIn() ?  SingleChildScrollView(
        child: GetBuilder<CheckoutController>(
          builder: (checkoutController) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                /// Amount Input
                CustomTextFieldWidget(
                  isAmount: true,
                  focusNode: amountFocusNode,
                  controller: amountController,
                  hintText: 'enter_amount'.tr,
                  labelText: 'amount'.tr,
                  onChanged: (String amount) {
                    if (amount.isNotEmpty) {
                      total = double.parse(amount);
                    } else {
                      total = 0;
                    }
                    applyDiscount();
                    setState(() {});
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                /// Discount view
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                  ),
                  child: Column(
                    children: [
                      if(discountPercent > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('discount'.tr, style: robotoRegular),
                        Text(
                          '${discountPercent.toStringAsFixed(2)}%',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                      ]),
                      if(discountPercent > 0) const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('payable_amount'.tr, style: robotoMedium),
                        Text(
                          PriceConverter.convertPrice(total),
                          textDirection: TextDirection.ltr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),
                /// Total Amount
                const SizedBox(height: Dimensions.paddingSizeSmall),


                /// Payment Method
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                  ),
                  // margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.fontSizeDefault),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(spacing: Dimensions.paddingSizeSmall, children: [
                        Text('payment_method'.tr, style: robotoMedium),
                        // checkoutController.isPartialPay && !ResponsiveHelper.isDesktop(context) ? Text('(${'partial_pay'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)) : const SizedBox(),
                      ]),

                      InkWell(
                        onTap: (){
                          if(ResponsiveHelper.isDesktop(context)){
                            Get.dialog(Dialog(backgroundColor: Colors.transparent, child: PaymentMethodBottomSheet2(
                              isCashOnDeliveryActive: false, isDigitalPaymentActive: true,
                              isWalletActive: true, totalPrice: total, isOfflinePaymentActive: false,
                            )));
                          }else {
                            showModalBottomSheet(
                              context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                              builder: (con) => PaymentMethodBottomSheet2(
                                isCashOnDeliveryActive: false, isDigitalPaymentActive: true,
                                isWalletActive: true, totalPrice: total, isOfflinePaymentActive: false,
                              ),
                            );
                          }
                          amountFocusNode.unfocus();
                        },
                        child: Image.asset(Images.paymentSelect, height: 24, width: 24),
                      ),
                    ]),

                    const Divider(),

                    Container(
                      // decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                      //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      //   color: Theme.of(context).cardColor,
                      //   border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), width: 1),
                      // ) : const BoxDecoration(),
                      // padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.radiusDefault) : EdgeInsets.zero,
                      child: checkoutController.paymentMethodIndex == 0 && !checkoutController.isPartialPay ? Row(children: [
                        Image.asset(Images.cash , width: 20, height: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Row(
                          children: [
                            Text('cash_on_delivery'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            ),
                            // checkoutController.checkoutController.isPartialPay ? Text('(${'partial_pay'.tr})', style: robotoRegular) : const SizedBox(),
                          ],
                        )),

                        Text(
                          PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        )

                      ]) : checkoutController.isPartialPay ? Column(children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('paid_by_wallet'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(
                            PriceConverter.convertPrice(walletBalance), textDirection: TextDirection.ltr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Text(
                            '${checkoutController.paymentMethodIndex == 0 ? 'cash_on_delivery'.tr
                                : checkoutController.paymentMethodIndex == 1 && !checkoutController.isPartialPay ? 'wallet_payment'.tr
                                : checkoutController.paymentMethodIndex == 2 ? '${'digital_payment'.tr} (${checkoutController.digitalPaymentName?.replaceAll('_', ' ').toTitleCase() ?? ''})'
                                : checkoutController.paymentMethodIndex == 3 ? '${'offline_payment'.tr} (${checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodName})'
                                : 'select_payment_method'.tr} ${checkoutController.paymentMethodIndex != 2 ? '(${'due'.tr})' : ''}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: checkoutController.paymentMethodIndex == 1 && checkoutController.isPartialPay ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge!.color),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          checkoutController.paymentMethodIndex == 1 && checkoutController.isPartialPay ? Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                            child: Icon(Icons.error, size: 16, color: Theme.of(context).colorScheme.error),
                          ) : const SizedBox(),

                          const Spacer(),

                          Text(
                            PriceConverter.convertPrice(total - walletBalance), textDirection: TextDirection.ltr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ]),

                      ]) : Row(children: [

                        checkoutController.paymentMethodIndex != -1 ? Image.asset(
                          checkoutController.paymentMethodIndex == 0 ? Images.cash
                              : checkoutController.paymentMethodIndex == 1 ? Images.wallet
                              : Images.digitalPayment,
                          width: 20, height: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ) : Icon(Icons.wallet_outlined, size: 18, color: Theme.of(context).disabledColor),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                            child: Row(children: [
                              Text(
                                checkoutController.paymentMethodIndex == 0 ? 'cash_on_delivery'.tr
                                    : checkoutController.paymentMethodIndex == 1 && !checkoutController.isPartialPay ? 'wallet_payment'.tr
                                    : checkoutController.paymentMethodIndex == 2 ? '${'digital_payment'.tr} (${checkoutController.digitalPaymentName?.replaceAll('_', ' ').toTitleCase() ?? ''})'
                                    : checkoutController.paymentMethodIndex == 3 ? '${'offline_payment'.tr} (${checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodName})'
                                    : 'select_payment_method'.tr,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              ),

                              checkoutController.paymentMethodIndex == -1 ? Padding(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.error, size: 16, color: Theme.of(context).colorScheme.error),
                              ) : /*checkoutController.isPartialPay ? Text('(${'partial_pay'.tr})', style: robotoRegular,) : */const SizedBox(),
                            ])
                        ),
                        !ResponsiveHelper.isDesktop(context) ? PriceConverter.convertAnimationPrice(
                          checkoutController.isPartialPay ? checkoutController.viewTotalPrice : total,
                          textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ) : const SizedBox(),

                      ]),
                    ),
                    // SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall),
                  ]),
                ),

              ]),
            );
          }
        ),
      ) : NotLoggedInScreen(callBack: (value){
        initCallData();
        setState(() {});
      }),
      bottomNavigationBar: isLoggedIn ? GetBuilder<CheckoutController>(
        builder: (checkoutController) {
          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
            ),
            height: 80,
            child: CustomButtonWidget(
              isLoading: checkoutController.isLoading,
              buttonText: 'pay_now'.tr,
              onPressed: amountController.text.isEmpty ? null : () async {
                if(double.parse(amountController.text.trim()) < 1) {
                  showCustomSnackBar('please_enter_valid_amount'.tr);
                  return false;
                }

                if(checkoutController.paymentMethodIndex == -1) {
                  if(ResponsiveHelper.isDesktop(context)){
                    Get.dialog(Dialog(backgroundColor: Colors.transparent, child: PaymentMethodBottomSheet2(
                      isCashOnDeliveryActive: false, isDigitalPaymentActive: true,
                      isWalletActive: true, totalPrice: total, isOfflinePaymentActive: false,
                    )));
                  }else{
                    showModalBottomSheet(
                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                      builder: (con) => PaymentMethodBottomSheet2(
                        isCashOnDeliveryActive: false, isDigitalPaymentActive: true,
                        isWalletActive: true, totalPrice: total, isOfflinePaymentActive: false,
                      ),
                    );
                  }
                  return true;
                }else if(checkoutController.paymentMethodIndex == 1 && Get.find<ProfileController>().userInfoModel
                    != null && Get.find<ProfileController>().userInfoModel!.walletBalance! < total) {
                  showCustomSnackBar('you_do_not_have_sufficient_balance_in_wallet'.tr);
                  return true;
                }
                else {
                  checkoutController.shanghaiPayment(amountController.text.trim(), widget.restaurant?.id.toString());
                }
              },
            ),
          );
        }
      ) : const SizedBox(),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
