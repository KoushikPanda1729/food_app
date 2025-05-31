import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/util/images.dart';

class PlatePleasersHeader extends StatelessWidget {
  const PlatePleasersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        ),
        child: ClipOval(
          child: Image.asset(
            Images.palatePleasersLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
