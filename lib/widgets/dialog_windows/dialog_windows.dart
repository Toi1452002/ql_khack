// import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

export 'dialog_funtion.dart';

class DialogWindows extends StatefulWidget {
  double width;
  double? height;
  String title;
  Widget child;
  void Function()? onClose;

  DialogWindows({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.onClose,
    required this.title,
  });

  @override
  State<DialogWindows> createState() => _DialogWindowsState();
}

class _DialogWindowsState extends State<DialogWindows> {
  void _close() {
    if (widget.onClose != null) {
      widget.onClose;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      padding: EdgeInsets.all(10),
      title:SizedBox(
        width: widget.width,
        child: Row(
          children: [
            Text(widget.title),
            Spacer(),
            IconButton.outline(
              icon: Icon(Icons.close),
              size: ButtonSize.small,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      // leading: IconButton.outline(
      //   icon: Icon(Icons.close),
      //   size: ButtonSize.small,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      content: SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.child,
      ),
    );
    // return SizedBox(
    //   width: widget.width,
    //   child: Dialog(
    //     shadowColor: Colors.black,
    //
    //     elevation: 15,
    //     insetPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
    //     child: SizedBox(
    //       width: widget.width,
    //       height: widget.height,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Container(
    //             height: 28,
    //             color: Colors.grey.shade200,
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 5),
    //               child: Row(
    //                 children: [
    //                   Text(widget.title, style: Theme.of(context).textTheme.labelMedium),
    //                   const Spacer(),
    //                   Material(
    //                     color: Colors.transparent,
    //                     child: SizedBox(
    //                       width: 40,
    //                       child: InkWell(
    //                         onTap: () => _close(),
    //                         child: Icon(
    //                           Icons.close,
    //                           color: Colors.red.shade700,
    //                           size: 20,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           Expanded(child: widget.child),
    //           // Expanded(child: widget.child)
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
