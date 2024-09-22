import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/khach/ds_khach_ngung_td/ds_kntd_state.dart';


class DsKntdNotifier extends StateNotifier<DsKntdState> {
  DsKntdNotifier() : super(DsKntdInit()){
    onGetKNTD();
  }

  final _khachData = KhachData();

  Future<void> onGetKNTD()async{
    state = DsKntdLoading();
    try{
      final rps = await _khachData.getKhachNgungTD();
      if(rps.statusCode==200){
        List data = jsonDecode(rps.data);
        state = DsKntdLoaded(lstKhach: data.map((e)=>Khach.fromMap(e)).toList());
      }else{
        state = DsKntdError(message: "Error connect");
      }

    }catch(e){
      state = DsKntdError(message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> onUpdateTheoDoi(int id) async{
    try{
      final rps = await _khachData.updateTheoDoi({
        'ID': id
      });
      if(rps.statusCode == 200){
        print(rps.data);
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> onDeleteKhach(int id) async{
    try{
      final rps = await _khachData.deleteKhach({
        'ID': id
      });
      if(rps.statusCode == 200){
        print(rps.data);
      }
    }catch(e){
      throw Exception(e);
    }
  }


}