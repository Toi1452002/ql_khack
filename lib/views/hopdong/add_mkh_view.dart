import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/application/makichhoat/makichhoat_provider.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ds_kichhoat.dart';
import '../../utils/alert.dart';
import '../../utils/string.dart';


class AddMKHView extends ConsumerWidget {
  final int maHD;
   AddMKHView({super.key, required this.maHD});

  static show(BuildContext context, int maHD, {void Function()? onClose}){
    showDialog(context: context, builder: (context){
      return AddMKHView(maHD: maHD,);
    }).then((val){
      onClose?.call();
    });
  }

  final txtSeri = TextEditingController();
  final txtMaKichHoat = TextEditingController();
  void add(WidgetRef ref, BuildContext context){
    if(txtMaKichHoat.text.trim().isEmpty){
      SmartAlert().showError('Mã kích hoạt trống');
      return;
    }

    DsKichhoat data = DsKichhoat(
        hopDongID: maHD,
        seri: txtSeri.text.trim(),
        maKichHoat: txtMaKichHoat.text.trim()
    );
    ref.read(maKichHoatProvider.notifier).addMKH(data, ref).whenComplete((){
      Navigator.pop(context);
    });


  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WidgetDialog(title: 'Thêm mã',width: 300, child: [
      WidgetTextField(label: 'Seri',controller: txtSeri, onChanged: (val) {
      if (val.length >= 16) {
        txtMaKichHoat.text = createBanQuyen(val);
            }
            if(val.isEmpty) txtMaKichHoat.clear();
    }),
      Gap(10),
      WidgetTextField(label: 'Mã kích hoạt',controller: txtMaKichHoat, onPressIcon: (){
        String randomString = "${generateRandomString(18)}z$maHD"; // Tạo chuỗi ngẫu nhiên độ dài 16
        txtMaKichHoat.text = randomString.toLowerCase();
      },
        readOnly: true,),
      Gap(20),
      sh.PrimaryButton(
        child: Text('Chấp nhận'),
        size: sh.ButtonSize.small,
        onPressed:() =>add(ref,context),
      ).sized(width: double.infinity)
    ]);
  }
   String generateRandomString(int length) {
     const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYabcdefghijklmnopqrstuvwxyz0123456789';
     final random = Random();
     return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
   }
}