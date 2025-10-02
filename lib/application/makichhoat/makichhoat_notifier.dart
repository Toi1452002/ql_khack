import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/application/makichhoat/makichhoat_provider.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/alert.dart';

import '../../data/datasource/ds_makichhoat.dart';


class MaKichHoatNotifier extends StateNotifier<List<DsKichhoat>> {
  MaKichHoatNotifier() : super([]);

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
          ref.read(selectedMKHProvider.notifier).state =  state.firstWhere((e)=>e.trangThai).id!;
        }
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<bool> changeMKH(DsKichhoat item)async{
    try{
      // print(item.toMap());
      final rps = await _dsKHData.post(item.toMap(),DsKichHoatDataType.changeMaKichHoat);
      if(rps.statusCode==200){
        return true;
      }
      return false;
    }catch(e){
      SmartAlert().showError(e.toString());
      return false;
    }
  }

  Future<bool> addMKH(DsKichhoat item, WidgetRef ref)async{
    try{
      final rps = await _dsKHData.post(item.toMap(),DsKichHoatDataType.addMKH);
      if(rps.statusCode==200){
        getMaKichHoat(item.hopDongID, ref);
        return true;
      }
      return false;

    }catch(e){
      SmartAlert().showError(e.toString());
      return false;
    }
  }
}