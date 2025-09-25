import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/alert.dart';

class KhachNotifier extends StateNotifier<KhachState> {
  KhachNotifier() : super(KhachInit()) {
    get();
  }

  final _khachData = KhachData();

  Future<void> get({int theoDoi = 1}) async {
    state = KhachLoading();
    try {
      final rp = await _khachData.getAllKhach(theoDoi: theoDoi);
      if (rp.statusCode == 200) {
        List data = jsonDecode(rp.data);
        state = KhachHasData(data: data.map((e) => Khach.fromMap(e)).toList());
      }
    } catch (e) {
      state = KhachError(message: e.toString());
    }
  }

  Future<int> onInsertKhach(Khach k) async {
    try {
      final rps = await _khachData.insertKhach(k.toMap());
      if (rps.statusCode == 200) {
        return int.parse(jsonDecode(rps.data));
      } else {
        return 0;
      }
    } catch (e) {
      SmartAlert().showError(e.toString());
      return 0;
    }
  }

  Future<bool> onDeleteKhach(int id) async {
    try {
      final rps = await _khachData.deleteKhach({'ID': id});
      if (rps.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      SmartAlert().showError(e.toString());
      return false;
    }
  }

  Future<bool> onUpdateKhach(Khach k) async {
    try {
      final rps = await _khachData.updateKhach(k.toMap());
      if (rps.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      SmartAlert().showError(e.toString());
      return false;
    }
  }
}
