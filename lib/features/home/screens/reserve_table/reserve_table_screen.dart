import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/reservation_form.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/reserve_table_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/restaurant_header.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class ReserveTableScreen extends StatefulWidget {
  const ReserveTableScreen({super.key});

  @override
  State<ReserveTableScreen> createState() => _ReserveTableScreenState();
}

class _ReserveTableScreenState extends State<ReserveTableScreen> {
  final ReserveTableController _controller = ReserveTableController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reserve a Table',
          style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).cardColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // Restaurant logo/header
                RestaurantHeader(),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Reservation form
                ReservationForm(controller: _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
