import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hopdong/hopdong.dart';

class HopdongNotifier extends StateNotifier<HopdongState> {
  HopdongNotifier() : super(HopdongInit()) {
    getViewHopDong();
  }

  final _hopDongData = HopdongData();
  final _khachData = KhachData();

  Future<void> getViewHopDong() async {
    state = HopdongLoading();
    try {
      final rsp = await _hopDongData.getViewHopDong();
      final rpsCopy = await _hopDongData.getHopDong();
      // print(rsp.data);
      List data = jsonDecode(rsp.data);
      List dataCopy = jsonDecode(rpsCopy.data);
      state = HopdongLoaded(
        lstHopdong: data.map((e) => Hopdong.fromMap(e)).toList(),
        lstHopdongCopy: dataCopy.map((e) => Hopdong.fromMap(e)).toList(),
      );
    } catch (e) {
      state = HopdongError(message: e.toString());
    }
  }

  Future<List<Khach>> getLstKhach() async {
    try {
      final response = await _khachData.getAllKhach();
      List lstData = jsonDecode(response.data);
      return lstData.map((e) => Khach.fromMap(e)).toList();
    } catch (e) {
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<int> onInsert(Hopdong hd) async {
    try {
      final rps = await _hopDongData.insert(hd.toMap());
      if (rps.statusCode == 200) {
        state = HopdongSuccess(message: 'Thêm thành công');
        return int.parse(jsonDecode(rps.data));
      } else {
        state = HopdongError(message: 'Add error');
        return 0;
      }
    } catch (e) {
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onUpdate(Hopdong hd) async {
    try {
      final rps = await _hopDongData.updateHD(hd.toMap());
      if (rps.statusCode == 200) {
        state = HopdongSuccess(message: 'Sửa thành công');
      } else {
        state = HopdongError(message: 'Update error');
      }
    } catch (e) {
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onGiaHan(String date, int id,Phieuthu pt) async{
    try {
        await _hopDongData.giaHanHD({
        'NgayHetHan': date,
        'ID': id
      });
    final rps = await PhieuthuData().post(pt.toMap(), PhieuThuType.insert);
      if (rps.statusCode == 200) {
        state = HopdongSuccess(message: 'Gia hạn thành công');
      } else {
        state = HopdongError(message: 'Update error');
      }
    } catch (e) {
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }



  Future<void> onGetDsMaKichHoat(WidgetRef ref, int maHD) async{
    try{
      final rps = await _hopDongData.getDSMaKichHoat({
        'HopDongID': maHD
      });

      if(rps.statusCode == 200){
        List data = jsonDecode(rps.data);
        ref.read(hdDsMaKichHoatPVD.notifier).state = data.map((e)=>DsKichhoat.fromMap(e)).toList();
      }
    }catch(e){
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }


  Future<void> onChangeMaKichHoat(int maHD, int newID,int oldID, String date) async{
    try{
      final rps = await _hopDongData.changeMaKichHoat({
        'NewID': newID,//id chua kich hoat
        'OldID': oldID,//id da kich hoat
        'HopDongID': maHD,
        'DateModified': date
      });

      if(rps.statusCode==200){
        // print(rps.data);
      }
    }catch(e){
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onChangeMKHkhachcu(String maKichHoat, int maHD)async{
    try{
      final rps = await _hopDongData.changeMKHkhachCu({
        'MaKichHoat' : maKichHoat,
        'HopDongID': maHD
      });
      if(rps.statusCode==200){
        // print(rps.data);
      }
    }catch(e){
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }
  
  Future<void> onUpdateHieuLuc(int id) async{
    try{
      final rps = await _hopDongData.updateHieuLuc({
        'ID': id
      });
      if(rps.statusCode == 200){
        state = HopdongSuccess(message: 'Update thành công');
      }
    }catch(e){
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }
  Future<void> onDeleteHopDong(int id) async{
    try{
      final rps = await _hopDongData.deleteHopDong({
        'ID': id
      });

      await _hopDongData.deleteSaoLuu({
        'fileName': id
      });
      if(rps.statusCode == 200){
        state = HopdongSuccess(message: 'Xóa thành công');
      }
    }catch(e){
      state = HopdongError(message: e.toString());
      throw Exception(e);
    }
  }
}
