import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:ql_khach/providers/providers.dart';
class Vphieuthu extends ConsumerWidget {
  const Vphieuthu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wChuaXacNhan = ref.watch(ptChuaXacNhanPVD);
    final wChuaThanhToan = ref.watch(ptChuaThanhToanPVD);

    ref.listen(phieuThuProvider, (_, state){
      if(state is PhieuThuLoading){
        SmartDialog.showLoading();
      }
      if(state is PhieuThuError){
        SmartAlert().showError(state.message);
      }
      if(state is PhieuThuSuccess){
        SmartAlert().showSuccess(state.message);
      }

      if(state is PhieuThuLoaded){
        SmartDialog.dismiss();
        // if(state.lstPhieuThu.isNotEmpty){
          final rDoanhSo = ref.read(ptDoanhSoPVD.notifier);
          final rChuaXacNhan = ref.read(ptChuaXacNhanPVD.notifier);
          final rChuaThanhToan = ref.read(ptChuaThanhToanPVD.notifier);
          final rTinhHH = ref.read(ptTinhHoaHong.notifier);
          int thang = DateTime.now().month;
          int year = DateTime.now().year;
          final tmp = state.lstPhieuThu.where((e){
            List<String> lstThang = e.thang.split('-');


            bool bY = int.parse(lstThang.first) > year;
            bool bT = int.parse(lstThang.last) >= thang;
            if(int.parse(lstThang.first) > year){
              return bY &&  e.TTTT != false && e.xacNhan != false;
            }else if(int.parse(lstThang.first) == year && bT){
              return true &&  e.TTTT != false && e.xacNhan != false;
            }
            return false;
          });
          rTinhHH.state = tmp.toList();
          rChuaThanhToan.state = state.lstPhieuThu.where((e)=>e.TTTT == false).toList();
          rChuaXacNhan.state = state.lstPhieuThu.where((e)=>e.xacNhan == false && e.TTTT == true).toList();
          rDoanhSo.state = state.lstPhieuThu.where((e)=>e.xacNhan == true).toList();
        // }
        // print(state.lstPhieuThu);
      }
    });

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: 30,
              child: TabBar(
                padding: EdgeInsets.zero,
                tabs: [
                  const FittedBox(child: Text('Doanh số')),
                  const FittedBox(child: Text('Tính HH')),
                  FittedBox(child: Text('Chưa xác nhận (${wChuaXacNhan.length})')),
                  FittedBox(child: Text('Chưa thanh toán (${wChuaThanhToan.length})')),
                ],
              ),
            ),
            Expanded(child: TabBarView(children: [
              PtTableDoanhso(),
              PtTinhHoahong(),
              PtChuaxacnhan(),
              PtChuathanhtoan(),
            ]))
          ],
        ),
      ),
    );
  }
}
