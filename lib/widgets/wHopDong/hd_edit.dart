import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

class HdEdit extends ConsumerWidget {
  Hopdong? hopdong;

  HdEdit({super.key, this.hopdong});

  final txtNgayHetHan = TextEditingController();
  final txtPhi = TextEditingController(text: '0');
  final txtThucThu = TextEditingController(text: '0');
  final txtMoTa = TextEditingController();
  final txtNguonKhach = TextEditingController();

  Future<void> _onEditHopDong(WidgetRef ref, BuildContext context) async {
    final thoiHan = ref.watch(hdThoiHanPVD);
    final product = ref.watch(productProvider);
    final khach = ref.watch(hdSelectKhachPVD);
    final dn = ref.watch(hdDoanhNghiepPVD);
    final hieuLuc = ref.watch(hdHieuLucpPVD);
    final user = ref.watch(userProvider);
    if (khach == null) {
      ref.read(hdErrorEditPVD.notifier).state = 'Chưa chọn khách';
      return;
    }
    if (product.productSelect == null) {
      ref.read(hdErrorEditPVD.notifier).state = 'Chưa chọn sản phẩm';
      return;
    }
    Hopdong hopDong = Hopdong(
        id: hopdong?.id,
        khachID: khach.maKH,
        moTa: txtMoTa.text.trim(),
        nguonKhach: txtNguonKhach.text.trim(),
        doanhNghiep: dn,
        userNameCreated: user!.username,
        userNameModified: user.username,
        dateModified: Helper.nowYmdT,
        hieuLuc: hieuLuc,
        maSP: product.productSelect == null ? '' : product.productSelect!,
        maSPCT: product.productDetailSelect == null
            ? ''
            : product.productDetailSelect!,
        thoiHan: thoiHan.toInt,
        phi: txtPhi.text.toDouble,
        thucThu: txtThucThu.text.toDouble);
    if (hopdong == null) {
      //Insert
      int id = await ref.read(hopdongProvider.notifier).onInsert(hopDong);
      if (id != 0) {
        _onClose(context, ref);
      }
    } else {
      //Update
      ref.read(hopdongProvider.notifier).onUpdate(hopDong);
      _onClose(context, ref);
    }
  }

  _onClose(BuildContext context, WidgetRef ref) {
    ref.refresh(productProvider);
    ref.refresh(hdThoiHanPVD);
    ref.refresh(hdSelectKhachPVD);
    ref.refresh(hdDoanhNghiepPVD);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final lstKhach = ref.watch(lstKhachProvider);
    final selectKhach = ref.watch(hdSelectKhachPVD);
    final wProduct = ref.watch(productProvider);
    final rProduct = ref.read(productProvider.notifier);
    final wThoiHan = ref.watch(hdThoiHanPVD);
    final rThoiHan = ref.read(hdThoiHanPVD.notifier);
    final wDoanhNghiep = ref.watch(hdDoanhNghiepPVD);
    final rDoanhNghiep = ref.read(hdDoanhNghiepPVD.notifier);
    final wErrorEdit = ref.watch(hdErrorEditPVD);
    final wHieuLuc = ref.watch(hdHieuLucpPVD);
    final rHieuLuc = ref.read(hdHieuLucpPVD.notifier);
    final sizeSmall = context.deviceSize.width < 500;
    if (hopdong != null) {
      txtNguonKhach.text = hopdong!.nguonKhach;
      txtMoTa.text = hopdong!.moTa;
      txtPhi.text = hopdong!.phi.toStringAsFixed(0);
      txtThucThu.text = hopdong!.thucThu.toStringAsFixed(0);
    }
    return Scaffold(
      backgroundColor: context.colorScheme.primary.withOpacity(.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        title: Text(
          'Thông tin hợp đồng ${hopdong == null ? '' : '(${hopdong!.id})'}',
          style: textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
        elevation: 0,
        titleSpacing: 5,
        leadingWidth: 40,
        actions: [
          InkWell(
              onTap: () => _onClose(context, ref),
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
            Row(
              children: [
                Wdropdown(
                  label: 'Khách',
                  screenSmall: sizeSmall,
                  selected: selectKhach == null
                      ? null
                      : '${selectKhach.maKH} - ${selectKhach.tenGoi}',
                  search: true,
                  data: lstKhach
                      .map((e) => DropdownItem(
                          value: "${e.maKH} - ${e.tenGoi}",
                          title: "${e.maKH} - ${e.tenGoi}"))
                      .toList(),
                  onChanged: (val) {
                    int maKh = val.toString().split(' -').first.toInt;
                    ref.read(hdSelectKhachPVD.notifier).state =
                        lstKhach.firstWhere((e) => e.maKH == maKh);
                  },
                  width: sizeSmall ? 100 : 200,
                ),
                Wtextfield(
                  width: sizeSmall ? 100 : 200,
                  label: '',
                  // enabled: false,
                  readOnly: true,
                  controller: TextEditingController(
                      text: selectKhach == null ? '' : selectKhach.tenMoRong),
                ),
                Gap(10),
                Expanded(
                  child: Wtextfield(
                    controller: txtNguonKhach,
                    label: 'Nguồn khách',
                  ),
                )
              ],
            ),
            const Gap(20),
            //San pham
            Row(
              children: [
                Wdropdown(
                    label: 'Sản phẩm',
                    width: sizeSmall ? 100 : 200,
                    screenSmall: sizeSmall,
                    selected: wProduct.productSelect,
                    onChanged: (val) {
                      rProduct.changeProduct(val.toString());
                    },
                    data: wProduct.lstProduct
                        .map((e) => DropdownItem(
                            value: e.maSP, title: "${e.maSP} ${e.moTa}"))
                        .toList()),
                Wdropdown(
                    width: sizeSmall ? 100 : 200,
                    screenSmall: sizeSmall,
                    label: 'Tên sản phẩm',
                    selected: wProduct.productDetailSelect,
                    onChanged: (val) {
                      rProduct.changeProductDetail(val.toString());
                    },
                    data: wProduct.lstProductDetail
                        .map((e) => DropdownItem(value: e.ma, title: e.moTa))
                        .toList()),
                Gap(10),
                Expanded(
                  child: Wtextfield(
                    controller: txtMoTa,
                    label: 'Mô tả',
                  ),
                )
              ],
            ),
            const Gap(20),
            Row(
              children: [
                Wdropdown(
                  label: 'Thời hạn',
                  width: sizeSmall ? 110 : 200,
                  screenSmall: sizeSmall,
                  selected: wThoiHan,
                  data: [
                    DropdownItem(value: '0', title: 'Không thời hạn'),
                    DropdownItem(value: '1', title: 'Tháng'),
                    DropdownItem(value: '2', title: 'Quý'),
                    DropdownItem(value: '3', title: 'Năm'),
                    DropdownItem(value: '4', title: 'Dùng thử (3N)'),
                  ],
                  onChanged: (val) {
                    rThoiHan.state = val.toString();
                  },
                ),
                Spacer(),
                Wtextfield(
                  label: 'Phí',
                  controller: txtPhi,
                  textAlign: TextAlign.end,
                  width: 100,
                ),
                Wtextfield(
                  label: 'Thực thu',
                  controller: txtThucThu,
                  textAlign: TextAlign.end,
                  width: 100,
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Checkbox(
                    value: wDoanhNghiep,
                    onChanged: (val) {
                      rDoanhNghiep.state = val!;
                    }),
                const Text('Doanh nghiệp'),
              ],
            ),
            if (hopdong != null)
              Row(
                children: [
                  Checkbox(
                      value: wHieuLuc,
                      onChanged: (val) {
                        rHieuLuc.state = val!;
                      }),
                  const Text('Hiệu lực')
                ],
              ),
            if (wErrorEdit != null)
              Text(
                wErrorEdit,
                style: TextStyle(color: context.colorScheme.error),
              ),
            const Spacer(),
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () => _onClose(context, ref),
                        child: const Text('Hủy')),
                    const Gap(15),
                    FilledButton(
                      onPressed: () => _onEditHopDong(ref, context),
                      child: const Text('Chấp nhận'),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
