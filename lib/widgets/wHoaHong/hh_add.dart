import 'package:data_table_2/data_table_2.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

final hhErrorInputPVD = StateProvider.autoDispose<String>((ref) {
  return '';
});

class HhAdd extends ConsumerStatefulWidget {
  HhAdd({super.key, required this.hoahong});

  Hoahong hoahong;

  @override
  HhAddState createState() => HhAddState();
}

class HhAddState extends ConsumerState<HhAdd> {
  final txtTuM = TextEditingController();
  final txtTuY = TextEditingController();
  final txtDenM = TextEditingController();
  final txtDenY = TextEditingController();
  final txtPhieuID = TextEditingController();

  @override
  void initState() {
    List<String> tmp = widget.hoahong.hoaHongThang.split('-');
    String tuM = DateTime.now().month.toString();
    txtDenM.text = tmp.last;
    txtDenY.text = tmp.first;
    txtTuM.text = tuM.length == 1 ? '0$tuM' : tuM;
    txtTuY.text = DateTime.now().year.toString();
    txtPhieuID.text = widget.hoahong.phieuThuID.toString();
    // TODO: implement initState
    super.initState();
  }

  void _onClose(BuildContext context) async {
    Navigator.pop(context);
    await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref);
  }

  void _addHoaHong(WidgetRef ref, BuildContext context) {
    final wSelectUser = ref.watch(selectItemDropdownPVD).lstSelect;
    final rErrorInput = ref.read(hhErrorInputPVD.notifier);
    final wUser = ref.watch(userProvider);
    rErrorInput.state = '';

    if (wSelectUser.isEmpty) {
      rErrorInput.state = 'Chưa chọn user';
      return;
    }
    try {
      if (txtTuM.text.toInt > 12 || txtTuM.text.toInt < 0) {
        rErrorInput.state = 'Thời gian không hợp lệ';
        return;
      }
      if (txtDenM.text.toInt > 12 || txtDenM.text.toInt < 0) {
        rErrorInput.state = 'Thời gian không hợp lệ';
        return;
      }
      DateTime tu = DateTime(txtTuY.text.toInt, txtTuM.text.toInt);
      DateTime den = DateTime(txtDenY.text.toInt, txtDenM.text.toInt);

      final thang = den.difference(tu).inDays ~/ 30;
      if (thang < 0) {
        rErrorInput.state = 'Thời gian không hợp lệ';
        return;
      }
      int tuThang = txtTuM.text.toInt;
      int tuNam = txtTuY.text.toInt;
      List<Map<String, dynamic>> data = [];

      for (int i = 0; i < thang + 1; i++) {
        String date = tuThang.toString().length == 1
            ? "$tuNam-0$tuThang"
            : "$tuNam-$tuThang";

        for (String x in wSelectUser) {
          String id = x.split('-').first;
          data.add({
            'PhieuThuID': widget.hoahong.phieuThuID,
            'UserID': id,
            'HoaHongThang': date,
            'UserNameCreated': wUser!.username,
          });
        }

        tuThang += 1;
        if (tuThang == 13) {
          tuThang = 1;
          tuNam += 1;
        }
      }

      ref
          .read(hoaHongProvider.notifier)
          .onAddHoaHong(data)
          .whenComplete(() async {
            await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref);
      });
    } catch (e) {
      rErrorInput.state = 'Thời gian không hợp lệ';
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final wLstUser = ref.watch(lstUserProvider);
    final wErrorInput = ref.watch(hhErrorInputPVD);
    final userTrueLV = ref.watch(userProvider)!.level > 1 ;
    final wListHH = ref
        .watch(lstHoaHongPVD)
        .where((e) => e.phieuThuID == widget.hoahong.phieuThuID)
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        elevation: 0,
        titleSpacing: 5,
        leadingWidth: 40,
        toolbarHeight: 25,
        title: Text(
          'Thêm hoa hồng',
          style: textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
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
      body: LayoutBuilder(builder: (context, size){
        if(size.maxWidth < 580){
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: size.maxWidth,
                  height: 300,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      bottom: BorderSide(color: context.colorScheme.primary),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wtextfield(
                            // label: 'Phiếu thu ID',
                            controller: txtPhieuID,
                            width: 100,
                            readOnly: true,
                          ),
                          const Gap(15),
                          WdropdownSelect(
                            width: size.maxWidth<350 ? 150 : null,
                            hintText: 'Chọn user',
                            items:
                            wLstUser.map((e) => "${e.id}-${e.username}").toList(),
                          ),

                          // const Gap(15),
                          // Row(
                          //   children: [
                          //     const Text('Đến: '),
                          //     const Spacer(),
                          //     Wtextfield(
                          //       width: 50,
                          //       hintText: 'MM',
                          //       controller: txtDenM,
                          //     ),
                          //     Wtextfield(
                          //       width: 50,
                          //       hintText: 'yyyy',
                          //       controller: txtDenY,
                          //     ),
                          //   ],
                          // ),
                          // const Spacer(),
                          // Text(
                          //   wErrorInput,
                          //   style: const TextStyle(color: Colors.red),
                          // ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: FilledButton(
                          //     onPressed:  userTrueLV ? () =>_addHoaHong(ref, context) : null,
                          //     child: const Text('Chấp nhận'),
                          //   ),
                          // )
                        ],
                      ),
                      Gap(10),
                      Row(
                        children: [
                          const Text('Từ: '),
                          Gap(10),
                          // const Spacer(),
                          Wtextfield(
                            width: 50,
                            hintText: 'MM',
                            controller: txtTuM,
                          ),
                          Wtextfield(
                            width: 50,
                            hintText: 'yyyy',
                            controller: txtTuY,
                          ),
                          Spacer(),
                          Text(
                            wErrorInput,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Gap(10),
                      Row(
                        children: [
                          const Text('Đến: '),
                          Wtextfield(
                            width: 50,
                            hintText: 'MM',
                            controller: txtDenM,
                          ),
                          Wtextfield(
                            width: 50,
                            hintText: 'yyyy',
                            controller: txtDenY,
                          ),
                          Spacer(),
                          FilledButton(
                            onPressed:  userTrueLV ? () =>_addHoaHong(ref, context) : null,
                            child: const Text('Chấp nhận'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: DataTable2(
                    minWidth: 500,
                    border: TableBorder.all(color: Colors.black, width: .2),
                    headingTextStyle: textTheme.titleSmall!
                        .copyWith(fontSize: 12, color: Colors.blue.shade900),
                    dataTextStyle: textTheme.bodySmall!.copyWith(fontSize: 12),
                    headingRowHeight: 25,
                    dataRowHeight: 25,
                    columnSpacing: 0,
                    horizontalMargin: 5,
                    // headingRowColor: WidgetStatePropertyAll(Colors.black.withOpacity(.3)),
                    columns: [
                      // DataColumn2(label: Text(''), fixedWidth: 20),
                      const DataColumn2(label: Text('ID'), fixedWidth: 30),
                      DataColumn2(label: _title('MaHD'), fixedWidth: 50),
                      // DataColumn2(label: Text('MaPhieu'), fixedWidth: 70),

                      DataColumn2(label: _title('User'), fixedWidth: 80),
                      DataColumn2(label: _title('NgayThu'), fixedWidth: 80),
                      DataColumn2(label: _title('HHThang')),
                      DataColumn2(
                          label: _title('TyleHH'), fixedWidth: 80, numeric: true),
                      DataColumn2(
                          label: _title('HoaHong'), fixedWidth: 80, numeric: true),
                      const DataColumn2(label: Text(''), fixedWidth: 30),
                    ],
                    rows: wListHH
                        .map(
                          (e) => DataRow2(cells: [
                        // DataCell(Text('')),
                        DataCell(Align(
                            alignment: Alignment.center,
                            child: Text(e.id.toString()))),
                        DataCell(Align(
                            alignment: Alignment.center,
                            child: Text(e.maHD.toString()))),
                        // DataCell(Text(e.phieuThuID.toString())),

                        DataCell(_title(e.user)),
                        DataCell(_title(Helper.dMy(e.ngayThu))),
                        DataCell(_title(Helper.My(e.hoaHongThang))),
                        DataCell(Wtextfield(
                          width: 80,
                          height: 24,
                          readOnly: !userTrueLV,
                          textAlign: TextAlign.end,
                          noneBorder: true,
                          onChanged: (val) {
                            EasyDebounce.debounce(
                                'updateTL', const Duration(milliseconds: 500),
                                    () {
                                  ref
                                      .read(hoaHongProvider.notifier)
                                      .onUpdateTyLe(val.toDouble, e.id!);
                                });
                          },
                          controller: TextEditingController(
                              text: e.tyleHH.toStringAsFixed(0)),
                        )),
                        DataCell(Wtextfield(
                          width: 80,
                          height: 24,
                          readOnly: !userTrueLV,
                          textAlign: TextAlign.end,
                          noneBorder: true,
                          onChanged: (val) {
                            EasyDebounce.debounce(
                                'updateTL', const Duration(milliseconds: 500),
                                    () {
                                  ref
                                      .read(hoaHongProvider.notifier)
                                      .onUpdateHoaHong(val.toDouble, e.id!);
                                });
                          },
                          controller: TextEditingController(
                              text: e.hoaHong.toStringAsFixed(0)),
                        )),
                        DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red.shade400,
                              ),
                            ),
                            onTap:!userTrueLV ? null : (){
                              SmartAlert().showInfo('Tiếp tục xóa?',onConfirm: () async{
                                ref.read(hoaHongProvider.notifier).onDeleteHoaHong(e.id!, ref);
                                // await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref);
                              });
                            }
                        ),
                      ]),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        }else{
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      right: BorderSide(color: context.colorScheme.primary),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wtextfield(
                        label: 'Phiếu thu ID',
                        controller: txtPhieuID,
                        width: 200,
                        readOnly: true,
                      ),
                      const Gap(15),
                      WdropdownSelect(
                        hintText: 'Chọn user',
                        items:
                        wLstUser.map((e) => "${e.id}-${e.username}").toList(),
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text('Từ: '),
                          const Spacer(),
                          Wtextfield(
                            width: 50,
                            hintText: 'MM',
                            controller: txtTuM,
                          ),
                          Wtextfield(
                            width: 50,
                            hintText: 'yyyy',
                            controller: txtTuY,
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text('Đến: '),
                          const Spacer(),
                          Wtextfield(
                            width: 50,
                            hintText: 'MM',
                            controller: txtDenM,
                          ),
                          Wtextfield(
                            width: 50,
                            hintText: 'yyyy',
                            controller: txtDenY,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        wErrorInput,
                        style: const TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed:  userTrueLV ? () =>_addHoaHong(ref, context) : null,
                          child: const Text('Chấp nhận'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: DataTable2(
                    minWidth: 500,
                    border: TableBorder.all(color: Colors.black, width: .2),
                    headingTextStyle: textTheme.titleSmall!
                        .copyWith(fontSize: 12, color: Colors.blue.shade900),
                    dataTextStyle: textTheme.bodySmall!.copyWith(fontSize: 12),
                    headingRowHeight: 25,
                    dataRowHeight: 25,
                    columnSpacing: 0,
                    horizontalMargin: 5,
                    // headingRowColor: WidgetStatePropertyAll(Colors.black.withOpacity(.3)),
                    columns: [
                      // DataColumn2(label: Text(''), fixedWidth: 20),
                      const DataColumn2(label: Text('ID'), fixedWidth: 30),
                      DataColumn2(label: _title('MaHD'), fixedWidth: 50),
                      // DataColumn2(label: Text('MaPhieu'), fixedWidth: 70),

                      DataColumn2(label: _title('User'), fixedWidth: 80),
                      DataColumn2(label: _title('NgayThu'), fixedWidth: 80),
                      DataColumn2(label: _title('HHThang')),
                      DataColumn2(
                          label: _title('TyleHH'), fixedWidth: 80, numeric: true),
                      DataColumn2(
                          label: _title('HoaHong'), fixedWidth: 80, numeric: true),
                      const DataColumn2(label: Text(''), fixedWidth: 30),
                    ],
                    rows: wListHH
                        .map(
                          (e) => DataRow2(cells: [
                        // DataCell(Text('')),
                        DataCell(Align(
                            alignment: Alignment.center,
                            child: Text(e.id.toString()))),
                        DataCell(Align(
                            alignment: Alignment.center,
                            child: Text(e.maHD.toString()))),
                        // DataCell(Text(e.phieuThuID.toString())),

                        DataCell(_title(e.user)),
                        DataCell(_title(Helper.dMy(e.ngayThu))),
                        DataCell(_title(Helper.My(e.hoaHongThang))),
                        DataCell(Wtextfield(
                          width: 80,
                          height: 24,
                          readOnly: !userTrueLV,
                          textAlign: TextAlign.end,
                          noneBorder: true,
                          onChanged: (val) {
                            EasyDebounce.debounce(
                                'updateTL', const Duration(milliseconds: 500),
                                    () {
                                  ref
                                      .read(hoaHongProvider.notifier)
                                      .onUpdateTyLe(val.toDouble, e.id!);
                                });
                          },
                          controller: TextEditingController(
                              text: e.tyleHH.toStringAsFixed(0)),
                        )),
                        DataCell(Wtextfield(
                          width: 80,
                          height: 24,
                          readOnly: !userTrueLV,
                          textAlign: TextAlign.end,
                          noneBorder: true,
                          onChanged: (val) {
                            EasyDebounce.debounce(
                                'updateTL', const Duration(milliseconds: 500),
                                    () {
                                  ref
                                      .read(hoaHongProvider.notifier)
                                      .onUpdateHoaHong(val.toDouble, e.id!);
                                });
                          },
                          controller: TextEditingController(
                              text: e.hoaHong.toStringAsFixed(0)),
                        )),
                        DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red.shade400,
                              ),
                            ),
                            onTap:!userTrueLV ? null : (){
                              SmartAlert().showInfo('Tiếp tục xóa?',onConfirm: () async{
                                ref.read(hoaHongProvider.notifier).onDeleteHoaHong(e.id!, ref);
                                // await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref);
                              });
                            }
                        ),
                      ]),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        }
      },),
    );
  }




  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Text(text),
    );
  }
}
