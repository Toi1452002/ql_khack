import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

import '../../data/data.dart';

class ThongTinHopDongView extends ConsumerStatefulWidget {
  final Hopdong? hopDong;

  const ThongTinHopDongView({super.key, this.hopDong});

  static void show(BuildContext context, {void Function()? close, Hopdong? hopDong}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ThongTinHopDongView(
            hopDong: hopDong,
          );
        }).then((val) {
      close?.call();
    });
  }

  @override
  ConsumerState createState() => _ThongTinHopDongViewState();
}

class _ThongTinHopDongViewState extends ConsumerState<ThongTinHopDongView> {
  final txtPhi = TextEditingController(text: '0');
  final txtThucThu = TextEditingController(text: '0');
  final txtMoTa = TextEditingController();
  final txtNguonKhach = TextEditingController();
  final txtSeri = TextEditingController();
  final txtTenKhach = TextEditingController();
  DateTime ngayHH = DateTime.now();

  // int? khachID;
  String? selectKhach;
  int thoiHan = 1;
  String? maSP;
  String? maSPCT;
  bool hieuLuc = true;
  bool doanhNghiep = false;

  List<Khach> lstKhach = [];
  List<Product> lstSP = [];
  List<ProductDetail> lstSPCT = [];
  List<ProductDetail> lstSPCTFilter = [];

  @override
  void initState() {
    // TODO: implement initState
    onLoadCBB();
    if (widget.hopDong != null) {
      final hd = widget.hopDong;
      txtTenKhach.text = hd!.tenMoRong;
      txtNguonKhach.text = hd.nguonKhach;
      txtMoTa.text = hd.moTa;
      txtPhi.text = hd.phi.toStringAsFixed(0);
      txtThucThu.text = hd.thucThu.toStringAsFixed(0);
      txtSeri.text = hd.seri;
      // khachID = hd.khachID;
      selectKhach = "${hd.khachID}-${hd.tenGoi}";
      maSP = hd.maSP;
      maSPCT = hd.maSPCT;
      thoiHan = hd.thoiHan;
      ngayHH = DateTime.parse(hd.ngayHetHan);
      hieuLuc = hd.hieuLuc;
      doanhNghiep = hd.doanhNghiep;
    }
    super.initState();
  }

  onLoadCBB() async {
    lstKhach = await ref.read(hopDongProvider.notifier).getKhach();
    lstSP = await ref.read(hopDongProvider.notifier).getMaSP();
    lstSPCT = await ref.read(hopDongProvider.notifier).getMaSPCT();
    if (maSP != null && maSP != '' && lstSP.isNotEmpty) {
      final productID = lstSP
          .firstWhere(
            (e) => e.maSP == maSP,
          )
          .id;
      lstSPCTFilter = lstSPCT.where((e) => e.productID == productID).toList();
    }
    setState(() {});
  }

  onSubmit() async {
    final user = ref.read(userProvider);
    Hopdong hopDong = Hopdong(
        id: widget.hopDong?.id,
        khachID: int.parse(selectKhach!.split('-').first),
        moTa: txtMoTa.text.trim(),
        nguonKhach: txtNguonKhach.text.trim(),
        doanhNghiep: doanhNghiep,
        seri: txtSeri.text.trim(),
        maKichHoat: txtSeri.text.isNotEmpty ? createBanQuyen(txtSeri.text.trim()) : '',
        userNameCreated: user!.username,
        userNameModified: user.username,
        dateModified: Helper.nowYmdT,
        hieuLuc: hieuLuc,
        maSP: maSP,
        maSPCT: maSPCT,
        thoiHan: thoiHan,
        phi: txtPhi.text.toDouble,
        thucThu: txtThucThu.text.toDouble);
    if (widget.hopDong == null) {
      final result = await ref.read(hopDongProvider.notifier).onInsert(hopDong);
      if (result != 0) {
        ref.read(hopDongSubmitProvider.notifier).state = true;
        Navigator.pop(context);
      }
    } else {
      hopDong.ngayHetHan = Helper.yMd(ngayHH);
      final result = await ref.read(hopDongProvider.notifier).onUpdate(hopDong);
      if (result) {
        ref.read(hopDongSubmitProvider.notifier).state = true;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetDialog(
      width: 500,
      title: 'Thông tin hợp đồng ${widget.hopDong == null ? '' : "| MaHD: ${widget.hopDong!.id}"}'.toUpperCase(),
      child: [
        Row(
          children: [
            Combobox(
              value: selectKhach,
              noSearch: false,
              columnWidth: [130, 170],
              menuWidth: 300,
              items: lstKhach
                  .map((e) => ComboboxItem(
                        value: "${e.ID}-${e.tenGoi}",
                        text: ["${e.ID}-${e.tenGoi}", e.tenMoRong],
                      ))
                  .toList(),
              onChanged: (val) {
                txtTenKhach.text =
                    lstKhach.firstWhere((e) => e.ID.toString() == val.toString().split('-').first).tenMoRong;
                setState(() {
                  selectKhach = val;
                });
              },
              label: 'Khách',
            ).sized(width: 100),
            WidgetTextField(
              label: '',
              readOnly: true,
              controller: txtTenKhach,
              // controller: TextEditingController(text: selectKhach == null ? '' : selectKhach.tenMoRong),
            ).expanded(),
            const Gap(10),
            Expanded(
              child: WidgetTextField(
                controller: txtNguonKhach,
                label: 'Nguồn khách',
              ),
            )
          ],
        ),
        Gap(15),
        Row(
          children: [
            Combobox(
              menuWidth: 250,
              columnWidth: [100, 150],
              items: lstSP.map((e) => ComboboxItem(value: e.maSP, text: [e.maSP, e.moTa])).toList(),
              value: maSP,
              onChanged: (val) {
                final id = lstSP.firstWhere((e) => e.maSP == val).id;
                setState(() {
                  lstSPCTFilter = lstSPCT.where((e) => e.productID == id).toList();
                  maSP = val;
                });
              },
              label: 'Mã SP',
            ).sized(width: 100),
            Combobox(
              menuWidth: 200,
              columnWidth: [50, 150],
              value: maSPCT,
              items: lstSPCTFilter.map((e) => ComboboxItem(value: e.ma, text: [e.ma, e.moTa])).toList(),
              onChanged: (val) {
                setState(() {
                  maSPCT = val;
                });
              },
              label: 'Tên sản phẩm',
            ).expanded(),
            const Gap(10),
            Expanded(
              child: WidgetTextField(
                controller: txtMoTa,
                label: 'Mô tả',
              ),
            )
          ],
        ),
        Gap(15),
        Row(
          children: [
            Combobox(
              value: thoiHan,
              items: [
                ComboboxItem(value: 0, text: ['Không thời hạn']),
                ComboboxItem(value: 1, text: ['Tháng']),
                ComboboxItem(value: 2, text: ['Quý']),
                ComboboxItem(value: 3, text: ['Năm']),
                ComboboxItem(value: 4, text: ['Dùng thử (3N)']),
              ],
              onChanged: (val) {
                setState(() {
                  thoiHan = val;
                });
              },
              label: 'Thời hạn',
            ).sized(width: 170),
            const Gap(10),
            Expanded(
              child: WidgetTextField(
                controller: txtPhi,
                textAlign: TextAlign.right,
                label: 'Phí',
              ),
            ),
            Expanded(
              child: WidgetTextField(
                controller: txtThucThu,
                textAlign: TextAlign.right,
                label: 'Thực thu',
              ),
            )
          ],
        ),
        Gap(15),
        Row(
          children: [
            WidgetTextField(
              controller: txtSeri,
              readOnly: widget.hopDong != null,
              label: 'Seri',
            ).expanded(),
            Gap(10),
            if (widget.hopDong != null)
              WidgetDateBox(
                initialDate: ngayHH,
                onChanged: (val) {},
                label: 'Ngày hết hạn',
              ).expanded()
          ],
        ),
        Gap(15),
        Row(
          children: [
            sh.Checkbox(
              state: hieuLuc ? sh.CheckboxState.checked : sh.CheckboxState.unchecked,
              onChanged: (val) {
                setState(() {
                  hieuLuc = val.index == 0;
                });
              },
              trailing: Text('Còn hiệu lực'),
            ),
            Gap(10),
            sh.Checkbox(
              state: doanhNghiep ? sh.CheckboxState.checked : sh.CheckboxState.unchecked,
              onChanged: (val) {
                setState(() {
                  doanhNghiep = val.index == 0;
                });
              },
              trailing: Text('Là doanh nghiệp'),
            ),
          ],
        ),
        Gap(20),
        sh.PrimaryButton(
          onPressed: onSubmit,
          size: sh.ButtonSize.small,
          child: Text(widget.hopDong == null ? 'Thêm' : 'Cập nhật'),
        ).sized(width: double.infinity)
      ],
    );
  }
}
