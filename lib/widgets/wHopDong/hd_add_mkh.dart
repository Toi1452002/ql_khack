import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';

import '../widgets.dart';

class HdAddMkh extends ConsumerWidget {
  int maHD;
  HdAddMkh({super.key, required this.maHD});

  void _onClose(BuildContext context) {
    Navigator.pop(context);
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
    ref.read(dsKichHoatProvider.notifier).addMKH(data, ref).whenComplete((){
      Navigator.pop(context);
    });


  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          backgroundColor: context.colorScheme.primary,
          title: Text(
            'Thêm mã',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          elevation: 0,
          titleSpacing: 5,
          leadingWidth: 40,
          actions: [
            InkWell(
                onTap: () => _onClose(context),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            const Gap(5),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Wtextfield(
                label: 'Seri',
                controller: txtSeri,
                onChanged: (val) {
                  if (val.length >= 16) {
                    txtMaKichHoat.text = createBanQuyen(val);
                  }
                  if(val.isEmpty) txtMaKichHoat.clear();
                },
              ),
              const Gap(15),
              Wtextfield(
                label: 'Mã kích hoạt',
                controller: txtMaKichHoat,
                suffixIcon: InkWell(
                  onTap: (){
                    String randomString = "${generateRandomString(18)}z$maHD"; // Tạo chuỗi ngẫu nhiên độ dài 16
                    txtMaKichHoat.text = randomString.toLowerCase();
                  },
                  child: Icon(
                    Icons.change_circle
                  ),
                ),
                readOnly: true,
              ),
              const Spacer(),
              FilledButton(onPressed: () =>add(ref,context), child: const Text('Chấp nhận'))
            ],
          ),
        ),
      ),
    );
  }
  String generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }
}
