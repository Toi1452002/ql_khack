import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/data/datasource/ds_makichhoat.dart';
// import 'package:ql_khach/widgets/wHopDong/hd_dsach_mkh.dart';

import '../providers/providers.dart';


class DskichhoatNotifier extends StateNotifier<List<DsKichhoat>> {
  DskichhoatNotifier() : super([]);
  final _dsKHData = DsMakichhoatData();

  Future<void> getMaKichHoat(int maHD, WidgetRef ref)async{
    try{
      final rps = await _dsKHData.get(DsKichHoatDataType.getDsMaKichHoat,data: {
        'HopDongID': maHD,
      });
      if(rps.statusCode==200){
        List data = jsonDecode(rps.data);
        state = data.map((e){
          return DsKichhoat.fromMap(e);
        }).toList();
        if(state.isNotEmpty){
          ref.read(selectKHProvider.notifier).state =  state.firstWhere((e)=>e.trangThai).id!;
        }
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> changeMKH(DsKichhoat item)async{
    try{
      // print(item.toMap());
      final rps = await _dsKHData.post(item.toMap(),DsKichHoatDataType.changeMaKichHoat);
      if(rps.statusCode==200){
        print(rps.data);
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> addMKH(DsKichhoat item, WidgetRef ref)async{
    try{
      // print(item.toMap());
      final rps = await _dsKHData.post(item.toMap(),DsKichHoatDataType.addMKH);
      if(rps.statusCode==200){
        print(rps.data);
        getMaKichHoat(item.hopDongID, ref);
      }

    }catch(e){
      throw Exception(e);
    }
  }

}