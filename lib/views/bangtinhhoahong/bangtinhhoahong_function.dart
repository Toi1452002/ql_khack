import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/alert.dart';
import 'package:trina_grid/trina_grid.dart';

class BangTinhHoaHongFunction {
  Future<List<User>> getUser() async {
    final rp = await UserData().getAllUser();
    if (rp.statusCode == 200) {
      List data = jsonDecode(rp.data);
      return data.map((e) => User.fromMap(e)).where((e) => e.nhanHH == true).toList();
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getBangTinhHoaHong(WidgetRef ref, int phieuThuID) async {
    final userLogin = ref.read(userProvider);
    final rp = await HoahongData().get(HoaHongDataType.getBangTinhHoaHong,
        data: {"PhieuThuID": phieuThuID, "Level": userLogin?.level, "UserID": userLogin?.id});
    if (rp.statusCode == 200) {
      final data = jsonDecode(rp.data);
      return data;
    } else {
      return [];
    }
  }

  Future<bool> addHang(List<int> user, int phieuThuID, WidgetRef ref, {required int tuT, required String tN, required List<dynamic> lstHH}) async {

    if (user.isEmpty) {
      SmartAlert().showError('Chưa chọn user');
      return false;
    }
    user.sort();
    final rev = user.reversed;
    String t = "$tN-${tuT.toString().length == 1 ? '0$tuT' : tuT}";
    List<Map<String, dynamic>> lstAdd = [];


    try{
      for (int x in rev) {
        final find = lstHH.indexWhere((e)=>e['HoaHongThang'] == t && e['UserID'] == x);
        if(find!=-1){
          SmartAlert().showError('Hoa hồng tháng $tuT/$tN của ${lstHH[find]['User']} đã tồn tại');
          return false;
        }

        lstAdd.add({
          "PhieuThuID": phieuThuID,
          "UserID": x,
          "HoaHongThang": t,
          "UserNameCreated": ref.read(userProvider)?.username
        });
      }

      final rp = await HoahongData().post({'listData': jsonEncode(lstAdd)}, HoaHongDataType.insert);
      if(rp.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      SmartAlert().showError(e.toString());
      return false;
    }


  }


  Future<void> onChanged(TrinaGridOnChangedEvent event) async{
    final field = event.column.field;
    if(field == 'NoiDung'){
      await HoahongData().post({
        "ID": event.row.cells['null']?.value,
        "NoiDung": event.value
      }, HoaHongDataType.updateNoiDung);

    }else if(field == "HoaHong"){
      await HoahongData().post({
        "ID": event.row.cells['null']?.value,
        "HoaHong": event.value
      }, HoaHongDataType.updateHoaHong);
    }
  }

  Future<void> deleteRow(int id, TrinaColumnRendererContext event) async{
    SmartAlert().showInfo("Tiếp tục xóa?",onConfirm: () async{
      await HoahongData().post({"ID": id}, HoaHongDataType.deleteHoaHong);
      event.stateManager.removeCurrentRow();
    });
  }

}
