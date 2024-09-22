import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu_state.dart';

class PhieuThuNotifier extends StateNotifier<PhieuThuState> {
  PhieuThuNotifier() : super(PhieuThuInit()){
    onGetPhieuThu();
  }
  final _ptData = PhieuthuData();

  Future<void> onGetPhieuThu()async{
    state = PhieuThuLoading();
    try{
      final rps = await _ptData.get(PhieuThuType.getPhieuThu);
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

  // Future<int> onAddPhieuThu(Phieuthu pt)async{
  //   try{
  //     final rps = await _ptData.post(pt.toMap(), PhieuThuType.insert);
  //     if(rps.statusCode == 200){
  //       final id = int.parse(jsonDecode(rps.data));
  //       // onGetPhieuThu();
  //       return id;
  //     }else{
  //       return 0;
  //     }
  //   }catch(e){
  //     throw Exception(e);
  //   }
  // }
  
  Future<void> onXacNhanTT(List<int> id,{bool isTTTT = false}) async{
    try{
      state = PhieuThuLoading();
      final rps = await _ptData.post({
        'lstID': id.join(',')
      },isTTTT ? PhieuThuType.xacNhanTTTT :  PhieuThuType.xacNhanTT);
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
}
