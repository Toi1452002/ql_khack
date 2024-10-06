import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';

final checkThanhToanPVD = StateProvider.autoDispose<bool>((ref) {
  return true;
});


class PtTaophieuthu extends ConsumerStatefulWidget {
  const PtTaophieuthu({super.key});

  @override
  PtTaophieuthuState createState() => PtTaophieuthuState();
}

class PtTaophieuthuState extends ConsumerState<PtTaophieuthu> {
  final textFieldKey = GlobalKey();
  final txtMaHD = TextEditingController();
  final txtSoTien = TextEditingController();
  final txtNgayThu = TextEditingController();
  final txtNguoiNop = TextEditingController();
  final txtNoiDung = TextEditingController();
  final txtThang = TextEditingController();
  final txtDsThang = TextEditingController();

  void _onTaoPhieuThu() {
    String dsThang = txtDsThang.text.trim();
    if(dsThang.isEmpty || dsThang.length!=7 ){
      SmartAlert().showError('Dso tháng không hợp lệ');
      return;
    }
    List<String> lstDsThang = dsThang.split('/');
    if(lstDsThang.first.length!=2 || lstDsThang.last.length!=4){
      SmartAlert().showError('Dso tháng không hợp lệ');
      return;
    }

    dsThang = "${lstDsThang.last}-${lstDsThang.first}";
    final user = ref.watch(userProvider);
    List<String> thang = txtThang.text.trim().split('/');
    Phieuthu phieuthu = Phieuthu(nguoiThu: user!.username,
        nguoiNop: txtNguoiNop.text.trim(),
        hopDongID: txtMaHD.text.toInt,
        soTien: txtSoTien.text.toDouble,
        noiDung: txtNoiDung.text.trim(),
        ngayThu: Helper.dMYtoYMD(txtNgayThu.text.trim()),
        userNameCreated: user.username,
        thang: "${thang.last}-${thang.first}",
        dsThang: dsThang,
        TTTT: ref.watch(checkThanhToanPVD));
    ref.read(phieuThuProvider.notifier).onAddPhieuThu(phieuthu);

    _close(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    txtSoTien.text = '0';
    txtNgayThu.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    txtThang.text = DateFormat("MM/yyyy").format(DateTime.now());
    txtDsThang.text = DateFormat("MM/yyyy").format(DateTime.now());
    super.initState();
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final wCheckThanhToan = ref.watch(checkThanhToanPVD);
    return SizedBox(
      width: 350,
      height: 420,
      child: Scaffold(
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
            const Gap(5),
          ],
          elevation: 0,
          titleSpacing: 5,
          title: Text(
            'Tạo phiếu thu',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          leadingWidth: 40,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Wtextfield(label: 'MaHD', width: 100, controller: txtMaHD,),
                  const Gap(15),
                  Expanded(
                    child: Wtextfield(
                      label: 'Số tiền',
                      textAlign: TextAlign.end,
                      controller: txtSoTien,),
                  ),

                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Wtextfield(label: 'Tháng HL',width: 100,controller: txtThang,),
                  const Gap(15),
                  Expanded(child: Wtextfield(
                    controller: txtNgayThu,
                    tKey: textFieldKey,
                    readOnly: true,
                    label: 'Ngày thu', suffixIcon: IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showWebDatePicker(
                        context: textFieldKey.currentContext!,
                        initialDate: Helper.dMytoDate(txtNgayThu.text),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 3650)),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 14000)),
                        width: 250,
                        // withoutActionButtons: true,
                        //weekendDaysColor: Colors.red,
                        //firstDayOfWeekIndex: 1,
                      );
                      if (pickedDate != null) {
                        txtNgayThu.text =
                            DateFormat("dd/MM/yyyy").format(pickedDate);
                      }
                    },
                    icon: const Icon(Icons.date_range, size: 15,),
                  ),))
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Wtextfield(
                    label: 'Người nộp', width: 100, controller: txtNguoiNop,),
                  const Gap(15),
                  Expanded(child: Wtextfield(
                    controller: txtNoiDung,
                    label: ' Nội dung',
                  ))
                ],
              ),
              const Gap(20),
              Wtextfield(
                width: 150,
                controller: txtDsThang,
                label: 'Dso Tháng',
              ),

              const Gap(20),
              Row(children: [
                Checkbox(value: wCheckThanhToan, onChanged: (val) {
                  ref.read(checkThanhToanPVD.notifier).state = !wCheckThanhToan;
                }),
                const Text('Đã thanh toán'),
              ],),
              const Spacer(),
              Align(alignment: Alignment.bottomRight,
                  child: FilledButton(
                      onPressed: () =>_onTaoPhieuThu(), child: const Text('Chấp nhận')))
            ],
          ),
        ),
      ),
    );
  }
}
