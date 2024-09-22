import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/widgets/widgets.dart';


class Walert extends StatelessWidget {
  Walert({super.key, required this.msg, required this.icon, this.onConfirm, this.focusNode});
  String msg;
  Icon icon;
  void Function()? onConfirm;
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return  Container(
      constraints: const BoxConstraints(maxHeight: 100),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(8),
      // height: 100,
      width: 350,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(2, 2))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const Gap(5),
          Expanded(child: SingleChildScrollView(child: SelectableText(msg))),
          if(onConfirm!=null) SizedBox(
            // height: 30,
            child: WtextButton(focusNode: focusNode,onPressed: (){
              SmartDialog.dismiss();
              onConfirm!();
            },text: 'OK',),
          ),
        ],
      ),
    );
  }
}
