import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/features/home/screens/reserve_table/reserve_table_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class PersonCounter extends StatefulWidget {
  final ReserveTableController controller;

  const PersonCounter({super.key, required this.controller});

  @override
  State<PersonCounter> createState() => _PersonCounterState();
}

class _PersonCounterState extends State<PersonCounter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Number of People: ${widget.controller.personCount}',
          style: robotoMedium.copyWith(fontSize: 16),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            setState(() {
              if (widget.controller.personCount > 1) {
                widget.controller.personCount--;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              Icons.remove,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        InkWell(
          onTap: () {
            setState(() {
              widget.controller.personCount++;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
