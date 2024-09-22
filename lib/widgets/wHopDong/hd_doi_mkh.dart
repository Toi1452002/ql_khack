import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hopdong/hopdong.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

final showMoreProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});


class HdDoiMkh extends ConsumerWidget {
  int maHD;
  HdDoiMkh({super.key, required this.maHD});

  final txtMaKichHoat = TextEditingController();

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }
  void _onChapNhan(BuildContext context, WidgetRef ref, int newID, int oldID){
    SmartAlert().showInfo('Tiếp tục đổi mã kích hoạt',onConfirm: (){
      ref.read(hopdongProvider.notifier).onChangeMaKichHoat(maHD, newID, oldID, Helper.yMd(DateTime.now(),hour: true)).whenComplete((){
        _onClose(context);
        SmartAlert().showSuccess('Đổi thành công');
        ref.refresh(hopdongProvider);
      });
    });
  }

  void _onKhachDaKichHoat(BuildContext context, WidgetRef ref, String maKichHoat){
    if(maKichHoat.isEmpty){
      return;
    }

    SmartAlert().showInfo('Hợp đồng sẽ được tự động kích hoạt',onConfirm: (){
      ref.read(hopdongProvider.notifier).onChangeMKHkhachcu(maKichHoat, maHD).whenComplete((){
        _onClose(context);
        SmartAlert().showSuccess('Đổi thành công');
        ref.refresh(hopdongProvider);
      });


    });
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wDsMaKichHoat = ref.watch(hdDsMaKichHoatPVD);
   final mkhNoAcTive = wDsMaKichHoat.firstWhere((e)=>e.trangThai == false,orElse: ()=>DsKichhoat());
   final mkhAcTive = wDsMaKichHoat.firstWhere((e)=>e.trangThai == true,orElse: ()=>DsKichhoat());

    final wshowM = ref.watch(showMoreProvider);
    final rshowM = ref.read(showMoreProvider.notifier);

    return SizedBox(
      width: 200,
      height: wshowM ? 220 : 140,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.colorScheme.primary,
          title: Text(
            'Đổi mã kích hoạt ($maHD)',
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Từng đổi mã kích hoạt lúc: ${Helper.dMy(mkhAcTive.dateModified,hour: true)}',style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: Colors.grey,

              ),),
              // Gap(20),
              Text('Đổi mã kích hoạt thành',style: context.textTheme.titleSmall,),
              Row(
                children: [
                  Wtextfield(
                    width: 170,
                    readOnly: true,
                    controller: TextEditingController(text: mkhNoAcTive.maKichHoat),
                  ),
                  Gap(5),
                  FilledButton(onPressed: ()=>_onChapNhan(context,ref,mkhNoAcTive.id!,mkhAcTive.id! ), child: Text('Ok'),),

                ],
              ),
              Visibility(visible: wshowM,child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  Divider(),
                  // Gap(30),
                  Text('Dùng cho khách cũ đã kích hoạt',style: context.textTheme.titleSmall),
                  Row(
                    children: [
                      Wtextfield(width: 170,hintText: 'Mã kích hoạt',controller: txtMaKichHoat,),
                      Gap(5),
                      FilledButton(onPressed: ()=>_onKhachDaKichHoat(context,ref,txtMaKichHoat.text), child: Text('Ok'),),

                    ],
                  ),
                ],
              )),
              Spacer(),
              Align(alignment: Alignment.centerRight,
                child: InkWell(onTap: (){
                  rshowM.state = !wshowM;
                }, child: Icon(Icons.arrow_drop_down,color: Colors.grey,)),
              )


            ],
          ),
        ),
      ),
    );
  }
}
