import 'package:flutter/material.dart';
import 'package:ql_khach/config/config.dart';


class MenuNotifier extends ChangeNotifier{
  String _select = RouterName.home;
  String get select => _select;

  bool _show = false;
  bool get isShow => _show;

  void changeSelect(String val){
    _select = val;
    notifyListeners();
  }

  void show(bool val){
    _show = val;
    notifyListeners();
  }

}