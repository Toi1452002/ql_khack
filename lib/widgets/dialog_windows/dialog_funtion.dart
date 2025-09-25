import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'dialog_windows.dart';

// Offset getCenterOffset(BuildContext context, double width, double height) {
//   double maxWidth = MediaQuery.of(context).size.width - width;
//   double maxHeight = MediaQuery.of(context).size.height - height;
//   return Offset(maxWidth / 2, maxHeight / 4 );
// }

Future<void> showCustomDialog(BuildContext context,
    {required String title,
    required double width,
     double? height,
    required Widget child,
    bool barrierDismissible = false,
     void Function()? onClose}) async {
  await showDialog(
      context: context,
      fullScreen: false,
      barrierColor: Colors.black.withValues(alpha: .1),
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return DialogWindows(
            width: width,
            height: height,
            onClose: onClose,
            title: title,
            child: child);
      });
}
