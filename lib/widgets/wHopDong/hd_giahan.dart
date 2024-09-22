import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';

class HdGiahan extends ConsumerStatefulWidget {
  Hopdong hd;

  HdGiahan({super.key, required this.hd});

  @override
  ConsumerState createState() => _HdGiahanState();
}

class _HdGiahanState extends ConsumerState<HdGiahan> {
  final txtSoTien = TextEditingController();
  final txtNguoiNop = TextEditingController();
  final txtNoiDung = TextEditingController();
  final txtNgayHetHan = TextEditingController();
  final textFieldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    txtSoTien.text = widget.hd.thucThu.toStringAsFixed(0);
    super.initState();
  }

  void _onClose(BuildContext context) {
    context.pop();
  }

  void _onChangeThoiHan(WidgetRef ref, String val) {
    ref.read(hdGHThoiHanPVD.notifier).state = val;
    final day = ref.watch(hdGHThoiHanPVD);
    DateTime dateGH = DateTime.parse(widget.hd.ngayHetHan);
    ref.read(hdGHNgayHetHanPVD.notifier).state =
        dateGH.add(Duration(days: numThoiHan[day]));
  }

  void _onSave(BuildContext context, WidgetRef ref) async{
    final user = ref.watch(userProvider);
    final tttt = ref.watch(hdGHThanhToanPVD);
    final Phieuthu phieuthu = Phieuthu(
        nguoiThu: user!.username,
        nguoiNop: txtNguoiNop.text,
        hopDongID: widget.hd.id!,
        soTien: txtSoTien.text.toDouble,
        noiDung: txtNoiDung.text,
        thang: _getThang(Helper.dMytoDate(txtNgayHetHan.text)),
        TTTT: tttt,
        userNameCreated: user.username);

    // ref.read(hopdongProvider.notifier).onGiaHan(Helper.dMYtoYMD(txtNgayHetHan.text), widget.hd.id!);
    ref.read(hopdongProvider.notifier).onGiaHan(Helper.dMYtoYMD(txtNgayHetHan.text), widget.hd.id!,phieuthu).whenComplete((){
      _onClose(context);

    });
  }

  String _getThang(DateTime ngayHetHan) {
    final now = DateTime.now();
    if (ngayHetHan.month == now.month && ngayHetHan.year == now.year) {
      return DateFormat('yyyy-MM').format(ngayHetHan);
    }
    DateTime date =
        DateTime(ngayHetHan.year, ngayHetHan.month - 1, ngayHetHan.day);
    return DateFormat('yyyy-MM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final wghThoiHan = ref.watch(hdGHThoiHanPVD);
    final wghNgayHetHan = ref.watch(hdGHNgayHetHanPVD);
    final wghThanhToan = ref.watch(hdGHThanhToanPVD);

    txtNgayHetHan.text = DateFormat('dd/MM/yyyy').format(wghNgayHetHan);
    return Scaffold(
      backgroundColor: context.colorScheme.primary.withOpacity(.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        title: Text(
          'Gia hạn (${widget.hd.id})',
          style: textTheme.titleSmall!.copyWith(color: Colors.white),
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
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 5,
              runSpacing: 15,

              children: [
                Wdropdown(
                  width: 150,
                  label: 'Thời hạn',
                  selected: wghThoiHan,
                  data: [
                    DropdownItem(value: '0', title: 'Khác'),
                    // DropdownItem(value: '0', title: 'Không thời hạn'),
                    DropdownItem(value: '1', title: '1 tháng'),
                    DropdownItem(value: '2', title: '1 quý'),
                    DropdownItem(value: '3', title: '1 năm'),
                    DropdownItem(value: '4', title: '3 ngày'),
                  ],
                  onChanged: (val) => _onChangeThoiHan(ref, val.toString()),
                ),
                Wtextfield(
                  label: 'Ngày hết hạn',
                  readOnly: true,
                  key: textFieldKey,
                  controller: txtNgayHetHan,
                  width: 150,
                  suffixIcon: IconButton(
                      onPressed: wghThoiHan != '0'
                          ? null
                          : () async {
                              DateTime? pickedDate = await showWebDatePicker(
                                context: textFieldKey.currentContext!,
                                initialDate:
                                    Helper.dMytoDate(txtNgayHetHan.text),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 7)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 14000)),
                                width: 250,
                                // withoutActionButtons: true,
                                //weekendDaysColor: Colors.red,
                                //firstDayOfWeekIndex: 1,
                              );
                              if (pickedDate != null) {
                                txtNgayHetHan.text = DateFormat("dd/MM/yyyy").format(pickedDate);
                              }
                            },
                      icon: const Icon(
                        Icons.date_range,
                        size: 15,
                      )),
                ),
                // const Spacer(),
                // Gap(15),
                Wtextfield(
                  label: 'Số tiền',
                  textAlign: TextAlign.end,
                  controller: txtSoTien,
                  width: 100,
                ),
              ],
            ),
            const Gap(20),
            Wrap(
              spacing: 5,
              runSpacing: 10,
              children: [
                Wtextfield(
                  label: 'Người nộp',
                  controller: txtNguoiNop,
                  width: 150,
                ),
                Wtextfield(
                  label: 'Nội dung',
                  width: 150,
                  controller: txtNoiDung,
                ),
              ],
            ),
            // const Gap(15),
            // Row(
            //   children: [
            //     Checkbox(
            //         value: wghThanhToan,
            //         onChanged: (val) {
            //           ref.read(hdGHThanhToanPVD.notifier).state = val!;
            //         }),
            //     const Text('Đã thanh toán')
            //   ],
            // ),
            // const Spacer(),

          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 35,
        child: Padding(
          padding: const EdgeInsets.only(right: 5,bottom: 5,left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                  value: wghThanhToan,
                  onChanged: (val) {
                    ref.read(hdGHThanhToanPVD.notifier).state = val!;
                  }),
              FittedBox(child: const Text('Đã thanh toán')),
              Spacer(),
              ElevatedButton(
                  onPressed: () => _onClose(context),
                  child: const Text('Hủy')),
              const Gap(15),
              FilledButton(
                  onPressed: () => _onSave(context, ref),
                  child: const Text('Chấp nhận'))
            ],
          ),
        ),
      ),
    );
  }
}

// class HdGiahan extends ConsumerWidget {
//   Hopdong hd;
//
//   HdGiahan({super.key, required this.hd});
//
//   final txtSoTien = TextEditingController();
//   final txtNguoiNop = TextEditingController();
//   final txtNoiDung = TextEditingController();
//   final txtNgayHetHan = TextEditingController();
//
//   void _onClose(BuildContext context) {
//     context.pop();
//   }
//
//   void _onChangeThoiHan(WidgetRef ref, String val){
//     // DateTime date = DateTime.now().add(Duration(days: numThoiHan[val]));
//     ref.read(hdGHThoiHanPVD.notifier).state = val;
//     // ref.read(hdGHNgayHetHanPVD.notifier).state = date;
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final textTheme = context.textTheme;
//     final wghThoiHan = ref.watch(hdGHThoiHanPVD);
//     final wghNgayHetHan = ref.watch(hdGHNgayHetHanPVD);
//
//     txtNgayHetHan.text = Helper.dMy(wghNgayHetHan);
//     txtSoTien.text = hd.thucThu.toStringAsFixed(0);
//
//     return Scaffold(
//       backgroundColor: context.colorScheme.primary.withOpacity(.1),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: context.colorScheme.primary,
//         title: Text(
//           'Gia hạn (${hd.id})',
//           style: textTheme.titleSmall!.copyWith(color: Colors.white),
//         ),
//         elevation: 0,
//         titleSpacing: 5,
//         leadingWidth: 40,
//         actions: [
//           InkWell(
//               onTap: () => _onClose(context),
//               child: const Icon(
//                 Icons.close,
//                 color: Colors.white,
//               )),
//           const Gap(5),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Wdropdown(
//                   label: 'Thời hạn',
//                   selected: wghThoiHan,
//                   data: [
//                     DropdownItem(value: '0', title: 'Khác'),
//                     DropdownItem(value: '1', title: '1 tháng'),
//                     DropdownItem(value: '2', title: '1 quý'),
//                     DropdownItem(value: '3', title: '1 năm'),
//                     DropdownItem(value: '4', title: '3 ngày'),
//                   ],
//                   onChanged: (val) =>_onChangeThoiHan(ref,val!),
//                 ),
//                 Wtextfield(
//                   label: 'Ngày hết hạn',
//                   readOnly: true,
//                   controller: txtNgayHetHan,
//                   width: 150,
//                   suffixIcon: const Icon(Icons.date_range),
//                 ),
//                 const Spacer(),
//                 Wtextfield(
//                   label: 'Số tiền',
//                   textAlign: TextAlign.end,
//                   controller: txtSoTien,
//                 ),
//               ],
//             ),
//             const Gap(20),
//             Row(
//               children: [
//                 Wtextfield(
//                   label: 'Người nộp',
//                   controller: txtNguoiNop,
//                 ),
//                 Wtextfield(
//                   label: 'Nội dung',
//                   width: 150,
//                   controller: txtNoiDung,
//                 ),
//               ],
//             ),
//             const Gap(15),
//             Row(
//               children: [
//                 Checkbox(value: false, onChanged: (val) {}),
//                 const Text('Đã thanh toán')
//               ],
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                     onPressed: () => _onClose(context),
//                     child: const Text('Hủy')),
//                 const Gap(15),
//                 FilledButton(onPressed: () {}, child: const Text('Chấp nhận'))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
