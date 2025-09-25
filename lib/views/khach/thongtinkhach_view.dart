import 'package:gap/gap.dart';
import 'package:ql_khach/application/application.dart';

// import 'package:ql_khach/widgets/dialog_windows/dialog_funtion.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

// import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../providers/user/user_provider.dart';
import '../../utils/utils.dart';

class ThongTinKhachView extends ConsumerStatefulWidget {
  const ThongTinKhachView({super.key, this.khach});

  final Khach? khach;

  static const name = "Thông tin khách hàng";

  // static void show(BuildContext context, {Khach? khach}) => showCustomDialog(context,
  //     title: name.toUpperCase(),
  //     width: 500,
  //     // height: 470,
  //     child: ThongTinKhachView(
  //       khach: khach,
  //     ));
  static void show(BuildContext context, {Khach? khach}) {
    showDialog(
        context: context,
        builder: (context) {
          return ThongTinKhachView(
            khach: khach,
          );
        });
  }

  @override
  ConsumerState createState() => _ThongTinKhachViewState();
}

class _ThongTinKhachViewState extends ConsumerState<ThongTinKhachView> {
  final txtTenGoi = TextEditingController();
  final txtTenMoRong = TextEditingController();
  final txtDiaChi = TextEditingController();
  final txtKhuVuc = TextEditingController();
  final txtTenCty = TextEditingController();
  final txtDienThoai = TextEditingController();
  final txtNguonLienHe = TextEditingController();
  final txtGhiChu = TextEditingController();
  bool theoDoi = true;

  @override
  void initState() {
    if (widget.khach != null) {
      final k = widget.khach;
      txtTenGoi.text = k!.tenGoi;
      txtTenMoRong.text = k.tenMoRong;
      txtDiaChi.text = k.diaChi;
      txtKhuVuc.text = k.khuVuc;
      txtTenCty.text = k.tenCty;
      txtDienThoai.text = k.dienThoai;
      txtNguonLienHe.text = k.nguonLienHe;
      txtGhiChu.text = k.ghiChu;
      theoDoi = k.theoDoi == 1 ? true : false;
    }
    super.initState();
  }

  void onSave() async {
    if (txtTenGoi.text.isEmpty) {
      SmartAlert().showError('Tên khách trống!');
      return;
    }
    final user = ref.read(userProvider);
    Khach khach = Khach(
        ID: widget.khach == null ? 0 : widget.khach!.ID,
        tenGoi: txtTenGoi.text.trim(),
        tenMoRong: txtTenMoRong.text.trim(),
        diaChi: txtDiaChi.text.trim(),
        nguonLienHe: txtNguonLienHe.text.trim(),
        tenCty: txtTenCty.text.trim(),
        userNameCreated: user!.username,
        userNameModified: user.username,
        dateModified: Helper.yMd(DateTime.now(), hour: true),
        ghiChu: txtGhiChu.text.trim(),
        khuVuc: txtKhuVuc.text.trim(),
        theoDoi: theoDoi ? 1 : 0,
        dienThoai: txtDienThoai.text.trim());
    if (widget.khach != null) {
      final result = await ref.read(khachProvider.notifier).onUpdateKhach(khach);
      if (result) {
        Navigator.pop(context);
        final theoDoi = ref.watch(khachTheoDoiProvider);
        ref.read(khachProvider.notifier).get(theoDoi: theoDoi);
      }
    } else {
      final result = await ref.read(khachProvider.notifier).onInsertKhach(khach);
      if (result != 0) {
        Navigator.pop(context);
        final theoDoi = ref.watch(khachTheoDoiProvider);
        ref.read(khachProvider.notifier).get(theoDoi: theoDoi);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetDialog(width: 500,title: "Thông tin khách hàng", child: [
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
      ),
      const Gap(15),
      Wtextfield(
        label: 'Ghi chú: ',
        controller: txtGhiChu,
        maxLines: 3,
      ),
      const Gap(10),
      sh.Checkbox(
          leading: const Text(
            'Khách đang theo dõi',
            style: TextStyle(fontSize: 13),
          ),
          state: theoDoi ? sh.CheckboxState.checked : sh.CheckboxState.unchecked,
          onChanged: (val) {
            setState(() {
              theoDoi = val.index == 0;
            });
          }),
      Gap(10),
      sh.PrimaryButton(
        onPressed: onSave,
        size: sh.ButtonSize.small,
        child: Text(widget.khach == null ? 'Thêm' : 'Cập nhật'),
      ).sized(width: double.infinity)
    ]);
    // return SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisSize: MainAxisSize.min,
    //     spacing: 10,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('asdas'),
    //           WidgetTextField(
    //             controller: txtTenGoi,
    //           ),
    //         ],
    //       ),
    //       WidgetCustomRow(
    //         columnWidths: {0: 110},
    //         items: [
    //           Text('Tên gọi').medium,
    //           WidgetTextField(
    //             controller: txtTenGoi,
    //           ),
    //         ],
    //       ),
    //       WidgetCustomRow(
    //         columnWidths: {0: 110},
    //         items: [
    //           Text('Tên mở rộng').medium,
    //           WidgetTextField(
    //             controller: txtTenMoRong,
    //           ),
    //         ],
    //       ),
    //       WidgetCustomRow(
    //         columnWidths: {0: 110},
    //         items: [
    //           Text('Địa chỉ').medium,
    //           WidgetTextField(
    //             controller: txtDiaChi,
    //           ),
    //         ],
    //       ),
    //       WidgetCustomRow(
    //         columnWidths: {0: 110},
    //         items: [
    //           Text('Khu vực').medium,
    //           WidgetTextField(
    //             controller: txtKhuVuc,
    //           ),
    //         ],
    //       ),
    //       WidgetCustomRow(columnWidths: {
    //         0: 110
    //       }, items: [
    //         Text('Tên Cty').medium,
    //         WidgetTextField(
    //           controller: txtTenCty,
    //         ),
    //       ]),
    //       WidgetCustomRow(columnWidths: {
    //         0: 110
    //       }, items: [
    //         Text('Điện thoại').medium,
    //         WidgetTextField(
    //           controller: txtDienThoai,
    //         ),
    //       ]),
    //       WidgetCustomRow(columnWidths: {
    //         0: 110
    //       }, items: [
    //         Text('Nguồn liên hệ').medium,
    //         WidgetTextField(
    //           controller: txtNguonLienHe,
    //         ),
    //       ]),
    //       WidgetCustomRow(columnWidths: {
    //         0: 110
    //       }, items: [
    //         Text('Ghi chú').medium,
    //         WidgetTextField(
    //           controller: txtGhiChu,
    //           maxLines: 2,
    //         ),
    //       ]),
    //       WidgetCustomRow(columnWidths: {
    //         0: 100
    //       }, items: [
    //         SizedBox(),
    //         Checkbox(
    //           state: theoDoi ? CheckboxState.checked : CheckboxState.unchecked,
    //           onChanged: (val) {
    //             setState(() {
    //               theoDoi = val.index == 0;
    //             });
    //           },
    //           trailing: const Text('Khách đang theo dõi'),
    //         ),
    //       ]),
    //       PrimaryButton(
    //         onPressed: onSave,
    //         child: Text(widget.khach == null ? 'Thêm' : 'Cập nhật'),
    //       ).withAlign(Alignment.center)
    //     ],
    //   ),
    // );
  }
}
