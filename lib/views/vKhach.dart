import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import '../config/config_pluto.dart';
import '../providers/providers.dart';



class Vkhach extends ConsumerWidget {
  const Vkhach({super.key});

  void _onNew(BuildContext context){
    showDialog(context: context,barrierDismissible: false, builder: (_){
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),

        child: SizedBox(
          width: 400,
          height: 450,
          child: KhachEdit(),
        ),
      );
    });
  }
  void _onEdit(WidgetRef ref, BuildContext context){
    final maKH = ref.watch(maKhachSelectProvider);
    if(maKH == null){
      SmartAlert().showInfo('Chưa chọn khách');
    }else{
      try{
        final khach = ref.watch(lstKhachProvider).firstWhere((e)=>e.maKH==maKH);
        showDialog(context: context,barrierDismissible: false, builder: (_){
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 400,
              height: 480,
              color: Colors.white,
              child: KhachEdit(
                khach: khach,
                title: 'Thông tin khách ($maKH)',
              ),
            ),
          );
        });
      }catch(e){
        SmartAlert().showInfo('Chưa chọn khách');
      }
    }
  }


  void _onKhachNgungTD(WidgetRef ref, BuildContext context){
    showDialog(context: context, builder: (_){
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: 800,
          height: 400,
          color: Colors.white,
          child: const KhachNgungTd(),
        ),
      );
    });
  }





  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.read(dsKhachTableProvider.notifier);
    final maKH = ref.watch(maKhachSelectProvider);
    final size = context.deviceSize.width;
    ref.listen(dsKhachProvider, (_, state) {
      if (state is DsKhachLoaded) {
        tableState.addAllRow(state.khach);
        ref.read(lstKhachProvider.notifier).state = state.khach;

      }
      if (state is DsKhachLoading) {
        tableState.stateManager.setShowLoading(true);
      }
      if (state is DsKhachError) {
        SmartAlert().showError(state.message);
      }

      if(state is DsKhachSuccess){
        // SmartAlert().showSuccess(state.message);
        ref.read(dsKhachProvider.notifier).onGetAllKhach();
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        backgroundColor: Colors.grey.shade200,
        actionsIconTheme:
            IconThemeData(size: 20, color: context.colorScheme.primary),
        titleSpacing: 0,
        title:Builder(
          builder: (context){
            if(size<370){
              return PopupMenuButton(offset: const Offset(30,0),color: Colors.white,itemBuilder: (context)=>[
                PopupMenuItem(height: 35,onTap: ()=>_onNew(context),child: const Text('Thêm'),),
                PopupMenuItem(height: 35,enabled: maKH!=null,onTap: ()=>_onEdit(ref,context),child: const Text('Sửa'),),
                PopupMenuItem(height: 35,onTap: ()=>_onKhachNgungTD(ref,context),child: const Text('Khách ngưng theo dõi'),),
              ]);
            }
            return Row(
              children: [
                WtextButton(onPressed: ()=>_onNew(context),text: 'Thêm',icon: Icons.add,),
                WtextButton(onPressed: ()=>_onEdit(ref,context),enable: maKH!=null,text: 'Sửa',icon: Icons.edit,),
                WtextButton(onPressed: ()=>_onKhachNgungTD(ref,context),text: 'Khách ngưng theo dõi',icon: Icons.edit_off_sharp,),

              ],
            );
          },
        ),
        actions: [
          Tooltip(
            message: 'Filter',
            child: WiconButton(
              icon: Icons.filter_alt,
              onTap: () {
                bool isShowFilter = tableState.stateManager.showColumnFilter;
                tableState.stateManager.setShowColumnFilter(!isShowFilter);
              },
            ),
          ),
          const Gap(5),
          Tooltip(
            message: 'Refresh',
            child: WiconButton(
              icon: Icons.refresh,
              onTap: () {
                ref.refresh(dsKhachProvider);
                ref.refresh(maKhachSelectProvider);
              },
            ),
          ),
          const Gap(15),
        ],
      ),
      body: KhachTable(),
    );
  }
}
