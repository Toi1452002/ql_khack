import 'package:flutter/material.dart';
import 'package:ql_khach/utils/extension.dart';

class Wtextfield extends StatelessWidget {
  String? label;
  String? hintText;
  Widget? suffixIcon;
  TextEditingController? controller;
  double height;
  bool? enabled;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  void Function()? onTap;
  Key? tKey;
  double? width;
  int? maxLines;
  bool autofocus;
  bool obscureText;
  bool readOnly;
  TextAlign textAlign;
  TextStyle? style;
  bool noneBorder;
  Wtextfield(
      {super.key,
      this.label,
      this.hintText,
      this.suffixIcon,
      this.controller,
      this.onSubmitted,
      this.onChanged,
      this.enabled,
      this.readOnly = false,
      this.onTap,
      this.tKey,
      this.width,
      this.maxLines,
      this.obscureText = false,this.textAlign = TextAlign.start,this.style,
      this.autofocus = false, this.noneBorder = false, this.height = 30 });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label ?? '',
            softWrap: false,
            style: context.textTheme.labelSmall!.copyWith(fontSize: 13),
          ),
        SizedBox(
            width: width ?? null,
            height: maxLines != null ? null : height,
            child: TextField(
              key: tKey,
              readOnly: readOnly,
              autofocus: autofocus,
              maxLines: maxLines??1,
              controller: controller,
              onChanged: onChanged,
              textAlign: textAlign,
              onSubmitted: onSubmitted,
              onTapOutside: (val){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onTap: onTap,
              enabled: enabled,
              style: style ?? const TextStyle(fontSize: 13),
              obscureText: obscureText,
              // cursorHeight: 15,

              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: hintText,
                  suffixIcon: suffixIcon,
                  hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  contentPadding: const EdgeInsets.only(left: 5,top: 5,right: 5,bottom: 5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide:
                          BorderSide(color: noneBorder ? Colors.transparent : Colors.black, width: .3)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                          color: noneBorder ? Colors.transparent : context.colorScheme.primary, width: .8))),
            )),
      ],
    );
  }
}
