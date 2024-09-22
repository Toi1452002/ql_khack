import 'package:flutter/material.dart';


class WiconButton extends StatelessWidget {
  void Function()? onTap;
  IconData icon;
  WiconButton({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}
