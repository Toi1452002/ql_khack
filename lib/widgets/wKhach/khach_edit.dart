import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/extension.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../../data/data.dart';

class KhachEdit extends ConsumerWidget {
  String? title;
  Khach? khach;

  KhachEdit({super.key, this.title, this.khach});

  final txtTenGoi = TextEditingController();
  final txtTenMoRong = TextEditingController();
  final txtDiaChi = TextEditingController();
  final txtKhuVuc = TextEditingController();
  final txtTenCty = TextEditingController();
  final txtDienThoai = TextEditingController();
  final txtNguonLienHe = TextEditingController();
  final txtGhiChu = TextEditingController();

  void _close(BuildContext context) {
    Navigator.pop(context);
    // SmartDialog.dismiss();
  }

  Future<void> _onSave(WidgetRef  ref, BuildContext context) async {
    if(txtTenGoi.text.isEmpty){
      ref.read(kErrorEditPVD.notifier).state = 'Tên khách trống!';
      return;
    }
    final tdoi = ref.watch(khachTheoDoiProvider);
    Khach khachEdit = Khach(
        maKH: khach == null ? 0 : khach!.maKH,
        tenGoi: txtTenGoi.text,
        tenMoRong: txtTenMoRong.text,
        diaChi: txtDiaChi.text,
        nguonLienHe: txtNguonLienHe.text,
        tenCty: txtTenCty.text,
        userNameCreated: ref.watch(userProvider)!.username,
        userNameModified: ref.watch(userProvider)!.username,
        dateModified: Helper.yMd(DateTime.now(),hour: true),
        ghiChu: txtGhiChu.text.toString(),
        khuVuc: txtKhuVuc.text,
        theoDoi: tdoi ? 1 : 0,
        dienThoai: txtDienThoai.text);
    if(khach!=null){//update
      ref.read(dsKhachProvider.notifier).onUpdateKhach(khachEdit);
      Navigator.pop(context);
    }else{
      int id = await  ref.read(dsKhachProvider.notifier).onInsertKhach(khachEdit);
      if(id!=0) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final wTheoDoi = ref.watch(khachTheoDoiProvider);
    final rTheoDoi = ref.read(khachTheoDoiProvider.notifier);
    final wError = ref.watch(kErrorEditPVD);

    final khach = this.khach;
    if (khach != null) {
      txtTenGoi.text = khach.tenGoi;
      txtTenMoRong.text = khach.tenMoRong;
      txtDiaChi.text = khach.diaChi;
      txtKhuVuc.text = khach.khuVuc;
      txtTenCty.text = khach.tenCty;
      txtDienThoai.text = khach.dienThoai;
      txtNguonLienHe.text = khach.nguonLienHe;
      txtGhiChu.text = khach.ghiChu;
      // rTheoDoi.state = khach.theoDoi==1 ? true : false;
    }

    return Scaffold(

      backgroundColor: context.colorScheme.primary.withOpacity(.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        actions: [
          InkWell(
              onTap: () => _close(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          Gap(5),
        ],
        elevation: 0,
        titleSpacing: 5,
        title: Text(
          title ?? 'Thông tin khách',
          style: textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
        leadingWidth: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Wtextfield(
                    controller: txtTenGoi,
                    label: 'Tên gọi: ',
                    // width: 150,
                  ),
                ),
                const Gap(10),
                Expanded(
                  flex: 2,
                  child: Wtextfield(
                    controller: txtTenMoRong,
                    label: 'Tên mở rộng: ',
                    // width: 220,
                  ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              children: [
                Expanded(
                  child: Wtextfield(
                    controller: txtDiaChi,
                    label: 'Địa chỉ: ',
                    // width: 150,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Wtextfield(
                    controller: txtKhuVuc,
                    label: 'Khu vực: ',
                    // width: 220,
                  ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              children: [
                Expanded(
                  child: Wtextfield(
                    controller: txtTenCty,
                    label: 'Tên cty: ',
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Wtextfield(
                    label: 'Điện thoại: ',
                    controller: txtDienThoai,
                  ),
                ),
              ],
            ),
            const Gap(15),
            Wtextfield(
              label: 'Nguồn liên hệ: ',
              controller: txtNguonLienHe,
              width: 380,
            ),
            const Gap(15),
            Wtextfield(
              label: 'Ghi chú: ',
              controller: txtGhiChu,
              width: 380,
              maxLines: 3,
            ),
            const Gap(10),
            if(khach!=null)Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Row(
                children: [
                  Checkbox(value: wTheoDoi, onChanged: (val) {
                    rTheoDoi.state = !wTheoDoi;
                  }),
                  const Gap(10),
                  const Text('Theo dõi')
                ],
              ),
            ),
            if(wError!=null) Text(wError,style: TextStyle(
              color: context.colorScheme.error
            ),),
            // const Gap(20),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: ()=>_close(context), child: const Text('Hủy')),
                const Gap(15),
                FilledButton(onPressed: ()=>_onSave(ref,context), child: const Text('Chấp nhận')),
              ],
            )

          ],
        ),
      ),
    );
  }
}
