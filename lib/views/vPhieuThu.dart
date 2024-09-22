import 'package:data_table_2/data_table_2.dart';
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

      if(state is PhieuThuLoaded){
        SmartDialog.dismiss();
        // if(state.lstPhieuThu.isNotEmpty){
          final rDoanhSo = ref.read(ptDoanhSoPVD.notifier);
          final rChuaXacNhan = ref.read(ptChuaXacNhanPVD.notifier);
          final rChuaThanhToan = ref.read(ptChuaThanhToanPVD.notifier);

          rChuaThanhToan.state = state.lstPhieuThu.where((e)=>e.TTTT == false).toList();
          rChuaXacNhan.state = state.lstPhieuThu.where((e)=>e.xacNhan == false && e.TTTT == true).toList();
          rDoanhSo.state = state.lstPhieuThu.where((e)=>e.xacNhan == true).toList();
        // }
        // print(state.lstPhieuThu);
      }
    });

    return DefaultTabController(
      length: 3,
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
                  FittedBox(child: Text('Chưa xác nhận (${wChuaXacNhan.length})')),
                  FittedBox(child: Text('Chưa thanh toán (${wChuaThanhToan.length})')),
                ],
              ),
            ),
            const Expanded(child: TabBarView(children: [
              PtTableDoanhso(),
              PtChuaxacnhan(),
              PtChuathanhtoan(),
            ]))
          ],
        ),
      ),
    );
  }
}
