import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/data/models/hopdong.dart';
import 'package:ql_khach/utils/alert.dart';

import '../../data/datasource/hopdong_data.dart';

class HopDongNotifier extends StateNotifier<HopDongState> {
  HopDongNotifier() : super(HopDongInit()) {
    getHopDong();
  }

  final hopDongData = HopdongData();

  Future<void> getHopDong({int hieuLuc = 1, int thoiHan = 1, int dN = 0}) async {
    state = HopDongLoading();
    try {
      final rp = await hopDongData.getViewHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: dN);
      if (rp.statusCode == 200) {
        List data = jsonDecode(rp.data);
        state = HopDongHasData(data: data.map((e) => Hopdong.fromMap(e)).toList());
      }
    } catch (e) {
      state = HopDongError(message: e.toString());
    }
  }

  Future<List<Khach>> getKhach() async {
    try {
      final rp = await KhachData().getAllKhach();
      if (rp.statusCode == 200) {
        List data = jsonDecode(rp.data);
        return data.map((e) => Khach.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      SmartAlert().showError(e.toString());
      return [];
    }
  }

  Future<List<Product>> getMaSP() async {
    try {
      final rp = await ProductData().getAllProduct();
      if (rp.statusCode == 200) {
        List data = jsonDecode(rp.data);
        return data.map((e) => Product.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      SmartAlert().showError(e.toString());
      return [];
    }
  }

  Future<List<ProductDetail>> getMaSPCT() async {
    try {
      final rp = await ProductData().getAllProductDetail();
      if (rp.statusCode == 200) {
        List data = jsonDecode(rp.data);
        return data.map((e) => ProductDetail.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      SmartAlert().showError(e.toString());
      return [];
    }
  }

  Future<int> onInsert(Hopdong hd) async {
    try {
      final rps = await hopDongData.insert(hd.toMap());
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

  Future<bool> onUpdate(Hopdong hd) async {
    try {
      final rps = await hopDongData.updateHD(hd.toMap());
      if (rps.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      SmartAlert().showError(e.toString());

      return false;
    }
  }

  Future<bool> onDeleteHopDong(int id) async {
    try {
      final rps = await hopDongData.deleteHopDong({'ID': id});

      await hopDongData.deleteSaoLuu({'fileName': id});
      if (rps.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      SmartAlert().showError(e.toString());
      return false;
    }
  }

  Future<bool> onGiaHan(String date, int id, Phieuthu pt) async {
    try {
      await hopDongData.giaHanHD({'NgayHetHan': date, 'ID': id});
      final rps = await PhieuthuData().post(pt.toMap(), PhieuThuType.insert);
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
