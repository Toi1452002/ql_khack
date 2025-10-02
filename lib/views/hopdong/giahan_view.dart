import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/helper.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

class GiaHanView extends ConsumerStatefulWidget {
  final Hopdong hopDong;

  const GiaHanView({super.key, required this.hopDong});

  static void show(BuildContext context, Hopdong hopDong, {void Function()? onClose}) {
    showDialog(
            context: context,
            builder: (context) => GiaHanView(
                  hopDong: hopDong,
                ),
            barrierDismissible: false)
        .then((val) {
      onClose?.call();
    });
  }

  @override
  ConsumerState createState() => _GiaHanViewState();
}

class _GiaHanViewState extends ConsumerState<GiaHanView> {
  int thoiHan = 1;
  DateTime ngayHH = DateTime.now();
  DateTime ngayHHBase = DateTime.now();
  final txtSoTien = TextEditingController(text: '0');
  final txtMaGiaHan = TextEditingController();
  final txtNguoiNop = TextEditingController();
  final txtNoiDung = TextEditingController();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
  int thang = DateTime.now().month;
  bool daThanhToan = true;

  @override
  void initState() {
    final hd = widget.hopDong;
    ngayHHBase = DateTime.parse(hd.ngayHetHan);
    thoiHan = hd.thoiHan;
    setNgayHH(hd.thoiHan);
    txtSoTien.text = hd.thucThu.toStringAsFixed(0);
    txtNguoiNop.text = hd.tenGoi;
    // txtNoiDung.text = 'Gia hạn';

    super.initState();
  }

  setNgayHH(int thoiHan) async {
    var dateHH = Jiffy.parseFromDateTime(ngayHHBase);
    if (thoiHan == 1) {
      ngayHH = dateHH.add(months: 1).dateTime;
    } else if (thoiHan == 2) {
      ngayHH = dateHH.add(months: 3).dateTime;
    } else if (thoiHan == 3) {
      ngayHH = dateHH.add(years: 1).dateTime;
    } else {
      ngayHH = dateHH.add(days: 3).dateTime;
    }
    setState(() {});
  }

  onGiaHan() async {
    String date = Helper.yMd(ngayHH);
    int id = widget.hopDong.id!;
    String dsThang = "${txtNam.text}-${thang.toString().length == 1 ? '0$thang' : thang.toString()}";
    final user = ref.read(userProvider);
    final Phieuthu pt = Phieuthu(
      nguoiThu: user!.username,
      nguoiNop: txtNguoiNop.text,
      hopDongID: id,
      ngayThu: Helper.yMd(DateTime.now()),
      soTien: double.tryParse(txtSoTien.text) ?? 0,
      noiDung: txtNoiDung.text,
      key: txtMaGiaHan.text,
      dsThang: dsThang,
      TTTT: daThanhToan,
      userNameCreated: user.username,
      thang: _getThang(ngayHH),
    );
    final result = await ref.read(hopDongProvider.notifier).onGiaHan(date, id, pt);
    if (result) {
      ref.read(hopDongSubmitProvider.notifier).state = true;
      Navigator.pop(context);
    }
  }

  String _getThang(DateTime ngayHetHan) {
    final now = DateTime.now();
    if (ngayHetHan.month == now.month && ngayHetHan.year == now.year) {
      return DateFormat('yyyy-MM').format(ngayHetHan);
    }
    DateTime date = DateTime(ngayHetHan.year, ngayHetHan.month - 1, ngayHetHan.day);
    return DateFormat('yyyy-MM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetDialog(width: 500, title: 'Gia hạn | MaHD: ${widget.hopDong.id}'.toUpperCase(), child: [
      Row(
        spacing: 10,
        children: [
          Combobox(
            value: thoiHan,
            label: 'Thời hạn',
            items: [
              ComboboxItem(value: 1, text: ['1 Tháng']),
              ComboboxItem(value: 2, text: ['1 Quý']),
              ComboboxItem(value: 3, text: ['1 Năm']),
              ComboboxItem(value: 4, text: ['Dùng thử (3N)']),
            ],
            onChanged: (val) {
              setNgayHH(val);
              setState(() {
                thoiHan = val;
              });
            },
          ).sized(width: 120),
          WidgetDateBox(
            initialDate: ngayHH,
            onChanged: (val) {
              setState(() {
                ngayHH = val!;
              });
            },
            label: 'Ngày hết hạn',
          ).expanded(),
        ],
      ),
      Gap(15),
      Row(
        spacing: 10,
        children: [
          WidgetTextField(
            label: 'Số tiền',
            controller: txtSoTien,
            textAlign: TextAlign.right,
          ).sized(width: 120),
          WidgetTextField(
              label: 'Mã gia hạn offline',
              controller: txtMaGiaHan,
              readOnly: true,
              onPressIcon: () {
                List<String> lstNgay = ["lg", "yi", "er", "sa", "si", "wu", "li", "qi", "ba", "ji"];
                String NgayHetHan = Helper.dMy(ngayHH);
                String key = '';

                for (int i = 0; i < NgayHetHan.length; i++) {
                  if (NgayHetHan[i] != '/') {
                    key += lstNgay[int.parse(NgayHetHan[i])];
                  }
                }
                key += 'per';
                txtMaGiaHan.text = key;
              },
              // suffixIcon: InkWell(
              //   onTap: ,
              //   child: ColoredBox(
              //     color: Colors.blue.shade700,
              //     child: const Icon(
              //       Icons.change_circle,
              //       size: 20,
              //       color: Colors.white,
              //     ),
              //   ),
              // )
          ).expanded(),
        ],
      ),
      Gap(15),
      Row(
        spacing: 10,
        children: [
          WidgetTextField(
            label: 'Người nộp',
            controller: txtNguoiNop,
          ).expanded(),
          WidgetTextField(
            label: 'Nội dung',
            controller: txtNoiDung,
          ).expanded(),
        ],
      ),
      Gap(15),
      Row(
        children: [
          Combobox(
            value: thang,
            items: [
              for (int i = 1; i <= 12; i++) ComboboxItem(value: i, text: ["$i"])
            ],
            label: 'DS tháng',
            onChanged: (val) {
              setState(() {
                thang = val;
              });
            },
          ).sized(width: 70),
          WidgetTextField(
            controller: txtNam,
            textAlign: TextAlign.center,
            label: '',
          ).sized(width: 60),
          Gap(10),
          Column(
            children: [
              Text(''),
              sh.Checkbox(
                state: daThanhToan ? sh.CheckboxState.checked : sh.CheckboxState.unchecked,
                onChanged: (val) {
                  setState(() {
                    daThanhToan = val.index == 0;
                  });
                },
                trailing: Text('Đã thanh toán'),
              )
            ],
          )
        ],
      ),
      Gap(20),
      sh.PrimaryButton(
        child: Text('Chấp nhận'),
        onPressed: onGiaHan,
        size: sh.ButtonSize.small,
      ).sized(width: double.infinity)
    ]);
  }
}
