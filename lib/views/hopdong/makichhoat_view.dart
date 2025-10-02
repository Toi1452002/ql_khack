import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/application/makichhoat/makichhoat_provider.dart';
import 'package:ql_khach/views/hopdong/add_mkh_view.dart';
import 'package:ql_khach/widgets/dialog_windows/dialog_funtion.dart';
import 'package:ql_khach/widgets/widget_dialog.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

import '../../data/models/ds_kichhoat.dart';
import '../../utils/utils.dart';

class MaKichHoatView extends ConsumerStatefulWidget {
  final int maHD;

  const MaKichHoatView({super.key, required this.maHD});

  static void show(BuildContext context, {required int maHD, void Function()? onClose}) {
    showCustomDialog(context,
        title: 'Mã kích hoạt | maHD: $maHD'.toUpperCase(),
        width: 400,
        height: 400,
        child: MaKichHoatView(
          maHD: maHD,
        )).then((val){
          onClose?.call();
    });
  }

  @override
  ConsumerState createState() => _MaKichHoatViewState();
}

class _MaKichHoatViewState extends ConsumerState<MaKichHoatView> {
  @override
  void initState() {
    // TODO: implement initState
    ref.read(maKichHoatProvider.notifier).getMaKichHoat(widget.maHD, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wMaKichHoat = ref.watch(maKichHoatProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sh.OutlineButton(
          child: Icon(Icons.add),
          size: sh.ButtonSize.small,
          onPressed: () {
            AddMKHView.show(context,widget.maHD);
          },
        ),
        ListView.builder(
            itemCount: wMaKichHoat.length,
            itemBuilder: (context, i) {
              final m = wMaKichHoat[i];
              return Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(.3),
                  ),
                  child: RadioListTile(
                      value: m.id,
                      title: Text(m.maKichHoat),
                      subtitle: Text("Seri: ${m.seri}"),
                      secondary: Text(Helper.dMy(m.dateModified)),
                      groupValue: ref.watch(selectedMKHProvider),
                      onChanged: (val) {
                        ref.read(selectedMKHProvider.notifier).state = val!;
                      }));
            }).expanded(),
        sh.PrimaryButton(
          size: sh.ButtonSize.small,
          onPressed: () {
            DsKichhoat kHoat = wMaKichHoat.firstWhere((e) => e.id == ref.watch(selectedMKHProvider));
            kHoat.dateModified = Helper.nowYmdT;
            SmartAlert().showInfo('Có chắc muốn thay đổi mã kích hoạt', onConfirm: () {
              ref.read(maKichHoatProvider.notifier).changeMKH(kHoat);
              ref.read(hopDongSubmitProvider.notifier).state = true;
              Navigator.pop(context);
            });
          },
          child: const Text('Chấp nhận'),
        ).sized(width: double.infinity)
      ],
    );
  }
}
