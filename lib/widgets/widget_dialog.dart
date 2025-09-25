import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;
class WidgetDialog extends StatelessWidget {
  final double? width;
  final List<Widget> child;
  final String title;
  const WidgetDialog({super.key, this.width,required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
      insetPadding: EdgeInsets.all(10),
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  sh.IconButton.outline(onPressed: (){
                    Navigator.pop(context);
                  },icon: Icon(Icons.close),size: sh.ButtonSize.small,)
                ],
              ),
              Gap(10),
              ...child
            ],
          ),
        ),
      ),
    );
  }
}
