import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/place_selection/screen/plate_pleasers/palate_pleasers_form.dart';
import 'package:stackfood_multivendor/features/place_selection/screen/plate_pleasers/palate_service_controller.dart';
import 'package:stackfood_multivendor/features/place_selection/screen/plate_pleasers/plate_pleasers_header.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class PlatePleasersPage extends StatefulWidget {
  const PlatePleasersPage({super.key});

  @override
  State<PlatePleasersPage> createState() => _ReserveTableScreenState();
}

class _ReserveTableScreenState extends State<PlatePleasersPage> {
  final PalateServiceController _controller = PalateServiceController();

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Book Service',
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
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // Restaurant logo/header
                PlatePleasersHeader(),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Reservation form
                PlatePleasersForm(controller: _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
