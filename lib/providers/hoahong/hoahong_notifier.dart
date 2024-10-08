import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hoahong/hoahong_provider.dart';
import 'package:ql_khach/providers/hoahong/hoahong_state.dart';

class HoahongNotifier extends StateNotifier<HoahongState> {
  HoahongNotifier() : super(HoahongInit());

  final _hoaHongData = HoahongData();

  Future<void> onGetHoaHong(WidgetRef ref, User user)async{
    // state = HoahongLoading();
    try{
      final rps = await _hoaHongData.get(HoaHongDataType.getAllHoaHong);
      if(rps.statusCode == 200){
        List data = jsonDecode(rps.data);
        final hoaHongData = data.map((e)=>Hoahong.fromMap(e)).toList();

        String HHThang  = DateFormat('yyyy-MM').format(DateTime.now());
        ref.read(lstHoaHongAllPVD.notifier).state =  hoaHongData.where((e)=>e.hoaHongThang == HHThang).toList();

        if(user.level>1){
          ref.read(lstHoaHongPVD.notifier).state =  hoaHongData;
        }else{
          ref.read(lstHoaHongPVD.notifier).state =  hoaHongData.where((e)=>e.user==user.fullname).toList();
        }
      }
      // return [];
    }catch(e){
      // state = HoahongError(message: e.toString());
      throw Exception(e);
    }
  }


  Future<void> onAddHoaHong(List<Map<String, dynamic>> data) async{
    try{
      final rps = await _hoaHongData.post({
        'listData':jsonEncode(data)
      }, HoaHongDataType.insert);
      if(rps.statusCode==200){
        // print(rps.data);
      }
    }catch(e){
      throw Exception(e);
    }
  }


  Future<void> onUpdateTyLe(double val, int id) async{
    try{
      final rps = await _hoaHongData.post({
        'TyLeHH': val,
        'ID': id
      }, HoaHongDataType.updateTyLe);
      if(rps.statusCode!=200){
        throw Exception('Update Fail');
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> onUpdateNoiDung(String val, int id) async{
    try{
      final rps = await _hoaHongData.post({
        'NoiDung': val,
        'ID': id
      }, HoaHongDataType.updateNoiDung);
      if(rps.statusCode!=200){
        throw Exception('Update Fail');
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<void> onUpdateHoaHong(double val, int id) async{
    try{
      final rps = await _hoaHongData.post({
        'HoaHong': val,
        'ID': id
      }, HoaHongDataType.updateHoaHong);
      if(rps.statusCode!=200){
        throw Exception('Update Fail');
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> onDeleteHoaHong(int id, WidgetRef ref, User user) async{
    try{
      final rps = await _hoaHongData.post({
        'ID': id
      }, HoaHongDataType.deleteHoaHong);
      if(rps.statusCode!=200){
        throw Exception('Delete Fail');
      }else{
        onGetHoaHong(ref, user);
      }
    }catch(e){
      throw Exception(e);
    }
  }
}
