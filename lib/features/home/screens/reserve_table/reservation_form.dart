import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/outlet_bottomsheet.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/person_counter.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/reserve_table_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class ReservationForm extends StatefulWidget {
  final ReserveTableController controller;

  const ReservationForm({super.key, required this.controller});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  void _onFormChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.nameController.addListener(_onFormChange);
    widget.controller.phoneController.addListener(_onFormChange);
  }

  @override
  void dispose() {
    widget.controller.nameController.removeListener(_onFormChange);
    widget.controller.phoneController.removeListener(_onFormChange);
    super.dispose();
  }

  // Date Bottom Sheet
  void _showDateBottomSheet() {
    DateTime initialDate = widget.controller.selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Date', style: robotoBold.copyWith(fontSize: 20)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: CalendarDatePicker(
                initialDate: initialDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (DateTime date) {
                  setState(() {
                    widget.controller.selectedDate = date;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Time Bottom Sheet
  void _showTimeBottomSheet() {
    final TimeOfDay initialTime = widget.controller.selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Time', style: robotoBold.copyWith(fontSize: 20)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: _buildTimePickerContent(initialTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerContent(TimeOfDay initialTime) {
    // Create a list of hourly time slots from 9 AM to 10 PM
    final List<TimeOfDay> timeSlots = [];
    for (int hour = 9; hour <= 22; hour++) {
      timeSlots.add(TimeOfDay(hour: hour, minute: 0));
      timeSlots.add(TimeOfDay(hour: hour, minute: 30));
    }

    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final TimeOfDay timeSlot = timeSlots[index];
        final bool isSelected = timeSlot.hour == initialTime.hour &&
            timeSlot.minute == initialTime.minute;

        return InkWell(
          onTap: () {
            setState(() {
              widget.controller.selectedTime = timeSlot;
            });
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeDefault,
            ),
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(timeSlot),
                  style: isSelected ? robotoMedium : robotoRegular,
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutletBottomSheet(controller: widget.controller),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextFieldWidget(
            controller: widget.controller.nameController,
            hintText: 'Your Name',
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          CustomTextFieldWidget(
            titleText: 'phone'.tr,
            controller: widget.controller.phoneController,
            inputType: TextInputType.phone,
            inputAction: TextInputAction.done,
            isPhone: true,
            showTitle: ResponsiveHelper.isDesktop(context),
            onCountryChanged: (CountryCode countryCode) {
              widget.controller.countryDialCode = countryCode.dialCode;
            },
            countryDialCode: widget.controller.countryDialCode != null
                ? CountryCode.fromCountryCode(
                        Get.find<SplashController>().configModel!.country!)
                    .code
                : Get.find<LocalizationController>().locale.countryCode,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          CustomTextFieldWidget(
            controller: widget.controller.emailController,
            hintText: 'Email (Optional)',
            inputType: TextInputType.emailAddress,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          _buildDateTimeSelectors(),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          PersonCounter(controller: widget.controller),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Center(
            child: Obx(
              () => CustomButtonWidget(
                isLoading: widget.controller.isLoading,
                onPressed: widget.controller.isFormValid()
                    ? () => widget.controller.submitReservation(context)
                    : null,
                buttonText: 'Reserve Table',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelectors() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date', style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              InkWell(
                onTap: () => _showDateBottomSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeDefault,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 20, color: Theme.of(context).primaryColor),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(widget.controller.selectedDate),
                        style: robotoRegular,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time', style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              InkWell(
                onTap: () => _showTimeBottomSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeDefault,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 20, color: Theme.of(context).primaryColor),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(
                        widget.controller.selectedTime.format(context),
                        style: robotoRegular,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
