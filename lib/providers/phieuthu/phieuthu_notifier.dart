import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/data/models/ds_kichhoat.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu_state.dart';
import 'package:ql_khach/utils/extension.dart';

class PhieuThuNotifier extends StateNotifier<PhieuThuState> {
  PhieuThuNotifier() : super(PhieuThuInit()){
    onGetPhieuThu();
  }
  final _ptData = PhieuthuData();
  final _hhData = HoahongData();
  Future<void> onGetPhieuThu()async{
    state = PhieuThuLoading();

    // String DsThang = thang?? DateFormat('yyyy-MM').format(DateTime.now());
    try{
      final rps = await _ptData.get(PhieuThuType.getPhieuThu,data: {
        // 'DsThang': DsThang
      });
      if(rps.statusCode == 200){
        List data = jsonDecode(rps.data);
        state = PhieuThuLoaded(lstPhieuThu: data.map((e)=>Phieuthu.fromMap(e)).toList());
      }else{
        state = PhieuThuError(message: "Error internet");

      }
    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onAddPhieuThu(Phieuthu pt)async{
    try{
      final rps = await _ptData.post(pt.toMap(), PhieuThuType.insert);
      if(rps.statusCode == 200){
        // final id = int.parse(jsonDecode(rps.data));
        onGetPhieuThu();
        state = PhieuThuSuccess(message: 'Tạo phiếu thu thành công');
        // return id;
      }else{
        state = PhieuThuError(message: "Error internet");
      }
    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }


  Future<void> onDeletePhieuThu(int id) async{
    try{
      final countHH = await _hhData.get(HoaHongDataType.getHHID,data: {
        'ID' : id
      });
      final data = jsonDecode(countHH.data).toString();
      // print(jsonDecode(countHH.data));
      if(data == '0'){
        final rps = await _ptData.post({
          "ID": id
        }, PhieuThuType.delete);
        if(rps.statusCode == 200){
          onGetPhieuThu();
          state = PhieuThuSuccess(message: 'Xóa thành công');
        }else{
          state = PhieuThuError(message: "Error internet");
        }
      }else{
          state = PhieuThuError(message: "Phiếu thu đang có hoa hồng, không thể xóa");
      }

    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }
  Future<void> onXacNhanTTTT(int id, String ngayThu, String dsThang) async{
    try{
      state = PhieuThuLoading();
      final rps = await _ptData.post({
        'id':id,
        'NgayThu': ngayThu,
        'DsThang': dsThang
      },PhieuThuType.xacNhanTTTT);
      if(rps.statusCode == 200){
        onGetPhieuThu();
      }else{
        state = PhieuThuError(message: "Error internet");
      }
    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onXacNhanTT(List<int> id, {bool isTTTT = false}) async{
    try{
      state = PhieuThuLoading();
      final rps = await _ptData.post({
        'lstID': id.join(',')
      },isTTTT ? PhieuThuType.xacNhanTTTT : PhieuThuType.xacNhanTT);
      if(rps.statusCode == 200){
        onGetPhieuThu();
      }else{
        state = PhieuThuError(message: "Error internet");
      }
    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onSuaPhieuThu(Phieuthu pt)async{
    try{
      final rps = await _ptData.post(pt.toMap(), PhieuThuType.update);
      if(rps.statusCode == 200){
        onGetPhieuThu();
        state = PhieuThuSuccess(message: 'Sửa thành công');
      }else{
        state = PhieuThuError(message: "Error internet");
      }
    }catch(e){
      state = PhieuThuError(message: e.toString());
      throw Exception(e);
    }
  }
}
