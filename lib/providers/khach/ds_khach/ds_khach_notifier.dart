import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/utils.dart';
import 'ds_khach_state.dart';

class DsKhachNotifier  extends StateNotifier<DsKhachState> {
  DsKhachNotifier() : super(DsKhachInit()){
    onGetAllKhach();
  }
  final _khachData = KhachData();

  Future<void> onGetAllKhach() async{
    state = DsKhachLoading();
    try{
      final response = await _khachData.getAllKhach();
      List lstData = jsonDecode(response.data);
      state = DsKhachLoaded(khach: lstData.map((e)=>Khach.fromMap(e)).toList());
    }catch(e){
      state = DsKhachError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<int> onInsertKhach(Khach k) async{
    try{
      final rps = await _khachData.insertKhach(k.toMap());
      if(rps.statusCode == 200){
        state = DsKhachSuccess(message: 'Thêm thành công');
        return int.parse(jsonDecode(rps.data));
      }else{
        state = DsKhachError(message: 'Error Server');
        return 0;
      }
    }catch(e){
      state = DsKhachError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onUpdateKhach(Khach k) async{
    try{
      final rps = await _khachData.updateKhach(k.toMap());
      if(rps.statusCode == 200){
        state = DsKhachSuccess(message: 'Sửa thành công');
      }else{
        state = DsKhachError(message: 'Error Server');
      }
    }catch(e){
      state = DsKhachError(message: e.toString());
      throw Exception(e);
    }
  }

}
