import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:ql_khach/widgets/widgets.dart';
enum AlertType{
  error,
  success,
  info;

  Icon get icon => switch(this){
    error => const Icon(Icons.error_outline, color: Colors.red,),
    success => const Icon(Icons.check,color: Colors.green,),
    info => const Icon(Icons.info_outline,color: Colors.grey,),
  };
}
class SmartAlert {

  void showError(String msg) {
    SmartDialog.show(
      alignment: Alignment.topCenter,
      builder: (_) => Walert(msg: msg, icon: AlertType.error.icon,),
    );
  }

  void showInfo(String msg,{void Function()? onConfirm,FocusNode? focusNode}){
    final focus = FocusNode();
    focus.requestFocus();
    SmartDialog.show(
      keepSingle: true,
      useAnimation: onConfirm==null,
      alignment: onConfirm!=null ? Alignment.center : Alignment.topCenter,
      builder: (_) => Walert(msg: msg, icon: AlertType.info.icon,onConfirm: onConfirm,focusNode: focus,),
    );
  }

  void showSuccess(String msg){
    SmartDialog.show(
      displayTime: const Duration(seconds: 2),
      alignment: Alignment.topCenter,
      builder: (_) => Walert(msg: msg, icon: AlertType.success.icon,),
    );
  }
}
