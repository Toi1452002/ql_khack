import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../utils/utils.dart';
import '../providers/providers.dart';
import 'package:jiffy/jiffy.dart';


class VHopDong extends ConsumerWidget {
  VHopDong({super.key});

  void _onNew(BuildContext context, WidgetRef ref) async{
    final rProduct = ref.read(productProvider.notifier);
    await rProduct.onGetAllProduct();
    await rProduct.onGetAllProductDetail();
    await showDialog(context: context,barrierDismissible: false, builder: (context){
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
        child: SizedBox(
          width: 590,
          height: 450,
          child: HdEdit(),
        ),
      );
    });
  }

  Future<void> _onEdit(BuildContext context,WidgetRef ref) async {
    int? maHD = ref.watch(hdMaHD);
    if(maHD==null){
      SmartAlert().showInfo('Chưa chọn hợp đồng');
      return;
    }
    final rProduct = ref.read(productProvider.notifier);
    final wKhach = ref.watch(lstKhachProvider);
    await rProduct.onGetAllProduct();
    await rProduct.onGetAllProductDetail();

    Hopdong hopdong = ref.watch(lstHopDongProvider).firstWhere((e)=>e.id==maHD);

    ref.read(hdThoiHanPVD.notifier).state = hopdong.thoiHan.toString();
    ref.read(hdDoanhNghiepPVD.notifier).state = hopdong.doanhNghiep;
    ref.read(hdHieuLucpPVD.notifier).state = hopdong.hieuLuc;
    rProduct.changeProduct(hopdong.maSP);
    rProduct.changeProductDetail(hopdong.maSPCT);
    ref.read(hdSelectKhachPVD.notifier).state = wKhach.firstWhere((e)=>e.maKH == hopdong.khachID);

    await showDialog(context: context,barrierDismissible: false, builder: (context){
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
        child: SizedBox(
          width: 590,
          height: 450,
          child: HdEdit(
            hopdong: hopdong,
          ),
        ),
      );
    });
  }


  void _onGiaHan(BuildContext context,WidgetRef ref){
    int? maHD = ref.watch(hdMaHD);
    if(maHD==null){
      SmartAlert().showInfo('Chưa chọn hợp đồng');
      return;
    }

    Hopdong hopdong = ref.watch(lstHopDongProvider).firstWhere((e)=>e.id==maHD);
    ref.read(hdGHThoiHanPVD.notifier).state = hopdong.thoiHan.toString();
    DateTime date = DateTime.parse(hopdong.ngayHetHan);
    var dateHH = Jiffy.parseFromDateTime(date);
    if(hopdong.thoiHan == 0)      dateHH = dateHH;
    if(hopdong.thoiHan == 1) dateHH  = dateHH.add(months: 1);
    if(hopdong.thoiHan == 2) dateHH  = dateHH.add(months: 3);
    if(hopdong.thoiHan == 3) dateHH  = dateHH.add(years: 1);
    if(hopdong.thoiHan == 4) dateHH  = dateHH.add(days: 3);



    // DateTime dateGH = DateTime.parse(hopdong.ngayHetHan).add(Duration(days: numThoiHan[hopdong.thoiHan.toString()]));

    ref.read(hdGHNgayHetHanPVD.notifier).state = dateHH.dateTime;
    showDialog(context: context, builder: (context){
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: 450,
          height: 400,
          child: HdGiahan(hd: hopdong,),
        ),
      );
    });
  }

  void _onDoiMKH(BuildContext context, WidgetRef ref){
    int? maHD = ref.watch(hdMaHD);
    if(maHD==null){
      SmartAlert().showInfo('Chưa chọn hợp đồng');
      return;
    }

    ref.read(hopdongProvider.notifier).onGetDsMaKichHoat(ref, maHD);
    showDialog(context: context, builder: (context){
      return Dialog(
        child: HdDoiMkh(maHD: maHD,),
      );
    });
  }

  void _hopDongKhongHieuLuc(BuildContext context, WidgetRef ref){
    showDialog(context: context, builder: (context){
      return const Dialog(
        child: SizedBox(
          width: 800,
          height: 400,
          child: HdHieuluc(),
        ),
      );
    });
  }


  void _refresh(HdTableNotifier hdTable, WidgetRef ref){
    hdTable.stateManager.setFilter(null);
    ref.refresh(hopdongProvider);
    ref.read(hdMaHD.notifier).state = null;
    ref.refresh(hdFilterTH);
    ref.refresh(hdFilterDN);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hdTable = ref.read(hdTableProvider.notifier);
    final rLstKhach = ref.read(lstKhachProvider.notifier);
    // final wLstHopDong = ref.watch(lstHopDongProvider);
    final size = context.deviceSize.width;
    int? maHD = ref.watch(hdMaHD);
    ref.listen(hopdongProvider, (_, state) async {
      if(state is HopdongLoaded){
        hdTable.filter(state.lstHopdong);
        ref.refresh(hdMaHD);
        ref.read(lstHopDongProvider.notifier).state = state.lstHopdongCopy;
        ref.read(lstHopDongViewPVD.notifier).state = state.lstHopdong;
        rLstKhach.state = await ref.read(hopdongProvider.notifier).getLstKhach(); // get danh sach khach de edit
        // _refresh(hdTable, ref);
        ref.refresh(hdFilterTH);
        ref.refresh(hdFilterDN);
        hdTable.stateManager.setFilter(null);

      }
      if(state is HopdongLoading){
        hdTable.stateManager.setShowLoading(true);
      }
      if (state is HopdongError) {
        SmartAlert().showError(state.message);
      }
      if(state is HopdongSuccess){
        // SmartAlert().showSuccess(state.message);
        ref.read(hopdongProvider.notifier).getViewHopDong();
      }
    });
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 25,
        actionsIconTheme:
        IconThemeData(size: 20, color: context.colorScheme.primary),
        title: Builder(
          builder: (context){
            if(size<550){
              return PopupMenuButton(offset: const Offset(30,0),color: Colors.white,itemBuilder: (context)=>[
                PopupMenuItem(height: 35,onTap: ()=>_onNew(context,ref),child: const Text('Thêm'),),
                PopupMenuItem(height: 35,enabled: maHD!=null,onTap: ()=>_onEdit(context,ref),child: const Text('Sửa'),),
                PopupMenuItem(height: 35,enabled:maHD!=null,onTap: ()=>_onGiaHan(context, ref),child: const Text('Gia hạn'),),
                PopupMenuItem(height: 35,enabled:maHD!=null,onTap: ()=>_onDoiMKH(context,ref),child: const Text('Đổi MKH'),),
                PopupMenuItem(height: 35,onTap: ()=>_hopDongKhongHieuLuc(context,ref),child: const Text('Hợp đồng không hiệu lực'),),
              ]);
            }
            return Row(
              children: [
                WtextButton(text: 'Thêm',icon: Icons.add,onPressed: ()=>_onNew(context,ref),),
                WtextButton(text: 'Sửa',icon: Icons.edit,enable:maHD!=null,onPressed: ()=>_onEdit(context,ref),),
                WtextButton(text: 'Gia hạn',icon: Icons.access_time_outlined,enable:maHD!=null,onPressed: ()=>_onGiaHan(context, ref),),
                WtextButton(text: 'Đổi MKH',icon: Icons.code,enable:maHD!=null,onPressed: ()=>_onDoiMKH(context,ref),),
                WtextButton(text: 'Hợp đồng không hiệu lực',icon: Icons.code,onPressed: ()=>_hopDongKhongHieuLuc(context,ref),),
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
                bool isShowFilter = hdTable.stateManager.showColumnFilter;
                hdTable.stateManager.setShowColumnFilter(!isShowFilter);
              },
            ),
          ),
          const Gap(5),
          Tooltip(
            message: 'Refresh',
            child: WiconButton(
              icon: Icons.refresh,
              onTap: () => _refresh(hdTable, ref),
            ),
          ),
          const Gap(15),
        ],
      ),
      body: HdTable(),
    );
  }
}