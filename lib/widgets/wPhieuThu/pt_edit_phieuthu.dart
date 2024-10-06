import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';

class PtEditPhieuthu extends ConsumerStatefulWidget {
  Phieuthu phieuthu;

  PtEditPhieuthu({super.key, required this.phieuthu});

  @override
  PtEditPhieuthuState createState() => PtEditPhieuthuState();
}

class PtEditPhieuthuState extends ConsumerState<PtEditPhieuthu> {
  final textFieldKey = GlobalKey();
  final txtSoTien = TextEditingController();
  final txtNgayThu = TextEditingController();
  final txtNguoiNop = TextEditingController();
  final txtNoiDung = TextEditingController();
  final txtThang = TextEditingController();
  final txtDsThang = TextEditingController();

  void _close() {
    Navigator.pop(context);
  }

  void onUpdate() {
    final user = ref.watch(userProvider);
    Phieuthu pt = Phieuthu(
        id: widget.phieuthu.id,
        nguoiNop: txtNguoiNop.text.trim(),
        soTien: txtSoTien.text.trim().toDouble,
        noiDung: txtNoiDung.text.trim(),
        thang: Helper.yM(txtThang.text.trim()),
        dsThang: Helper.yM(txtDsThang.text.trim()),
        ngayThu: Helper.dMYtoYMD(txtNgayThu.text.trim()),
        dateModified: Helper.nowYmdT,
        userNameModified:user!.username,
    );
    ref.read(phieuThuProvider.notifier).onSuaPhieuThu(pt);
    _close();
  }

  @override
  void initState() {
    // TODO: implement initState
    txtSoTien.text = widget.phieuthu.soTien.toStringAsFixed(0);
    txtDsThang.text = Helper.My(widget.phieuthu.dsThang);
    txtNguoiNop.text = widget.phieuthu.nguoiNop;
    txtNoiDung.text = widget.phieuthu.noiDung;
    txtThang.text = Helper.My(widget.phieuthu.thang);
    txtNgayThu.text = Helper.dMy(widget.phieuthu.ngayThu!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 350,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.colorScheme.primary,
          actions: [
            InkWell(
                onTap: () => _close(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            const Gap(5),
          ],
          elevation: 0,
          titleSpacing: 5,
          title: Text(
            'Sửa phiếu thu (${widget.phieuthu.id})',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          leadingWidth: 40,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Wtextfield(
                    label: 'Tháng',
                    width: 100,
                    controller: txtThang,
                  ),
                  const Gap(15),
                  Expanded(
                      child: Wtextfield(
                    controller: txtNgayThu,
                    tKey: textFieldKey,
                    readOnly: true,
                    label: 'Ngày thu',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showWebDatePicker(
                          context: textFieldKey.currentContext!,
                          initialDate: Helper.dMytoDate(txtNgayThu.text),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 3650)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 14000)),
                          width: 250,
                        );
                        if (pickedDate != null) {
                          txtNgayThu.text =
                              DateFormat("dd/MM/yyyy").format(pickedDate);
                        }
                      },
                      icon: const Icon(
                        Icons.date_range,
                        size: 15,
                      ),
                    ),
                  ))
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Wtextfield(
                    label: 'Người nộp',
                    width: 100,
                    controller: txtNguoiNop,
                  ),
                  const Gap(15),
                  Expanded(
                      child: Wtextfield(
                    controller: txtNoiDung,
                    label: ' Nội dung',
                  ))
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Wtextfield(
                    width: 150,
                    controller: txtDsThang,
                    label: 'Dso Tháng',
                  ),
                  const Gap(15),
                  Expanded(
                    child: Wtextfield(
                      label: 'Số tiền',
                      textAlign: TextAlign.end,
                      controller: txtSoTien,
                    ),
                  ),
                ],
              ),
              Gap(10),
              Wtextfield(label: 'Key',readOnly: true,width: 200,controller: TextEditingController(text: widget.phieuthu.key),),
              const Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child:
                      FilledButton(onPressed: ()=>onUpdate(), child: const Text('Chấp nhận')))
            ],
          ),
        ),
      ),
    );
  }
}
