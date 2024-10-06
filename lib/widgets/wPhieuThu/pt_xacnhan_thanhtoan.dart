import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';

class PtXacnhanThanhtoan extends ConsumerStatefulWidget {
  PtXacnhanThanhtoan(
      {super.key,
      required this.ngayThu,
      required this.phieuThu,
      required this.dsThang});

  String ngayThu;
  String dsThang;
  int phieuThu;

  @override
  PtXacnhanThanhtoanState createState() => PtXacnhanThanhtoanState();
}

class PtXacnhanThanhtoanState extends ConsumerState<PtXacnhanThanhtoan> {
  void _close() {
    Navigator.pop(context);
  }

  final textFieldKey = GlobalKey();
  final txtNgayThu = TextEditingController();
  final txtDsThang = TextEditingController();

  void onXacNhan() {
    List lstDsoThang = txtDsThang.text.split('/');
    String dsThang = lstDsoThang.last + "-" + lstDsoThang.first;
    ref.read(phieuThuProvider.notifier).onXacNhanTTTT(
        widget.phieuThu, Helper.dMYtoYMD(txtNgayThu.text), dsThang);
    _close();
  }

  @override
  void initState() {
    // TODO: implement initState
    txtNgayThu.text = widget.ngayThu;
    txtDsThang.text = widget.dsThang;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return SizedBox(
      width: 150,
      height: 240,
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
            'Xác nhận thanh toán (${widget.phieuThu})',
            style: textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          leadingWidth: 40,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wtextfield(
                label: 'Ngày thu',
                width: 200,
                readOnly: true,
                tKey: textFieldKey,
                controller: txtNgayThu,
                suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showWebDatePicker(
                      context: textFieldKey.currentContext!,
                      initialDate: Helper.dMytoDate(txtNgayThu.text),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 7)),
                      lastDate: DateTime.now().add(const Duration(days: 14000)),
                      width: 250,
                    );
                    if (pickedDate != null) {
                      txtNgayThu.text =
                          DateFormat("dd/MM/yyyy").format(pickedDate);
                    }
                  },
                  icon: Icon(
                    Icons.date_range,
                    size: 15,
                  ),
                ),
              ),
              Gap(15),
              Wtextfield(
                width: 200,
                controller: txtDsThang,
                label: 'Doanh số tháng',
              ),
              Gap(15),
              FilledButton(
                  onPressed: () {
                    onXacNhan();
                  },
                  child: const Text('Xác nhận đã thanh toán'))
            ],
          ),
        ),
      ),
    );
  }
}
