import 'package:flutter/material.dart';

class WtextButton extends StatelessWidget {
  WtextButton(
      {super.key,
      this.onPressed,
      this.enable = true,
      required this.text,
        this.focusNode,this.color,
      this.icon});

  void Function()? onPressed;
  bool enable;
  String text;
  IconData? icon;
  FocusNode? focusNode;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      // autofocus: true,
      focusNode: focusNode,
      onPressed: enable ? onPressed : null,
      child: Row(
        children: [
          FittedBox(child: Text(text, style: TextStyle(color: color),)),
          Icon(
            icon,
            size: 10,
          )
        ],
      ),
    );
  }
}
