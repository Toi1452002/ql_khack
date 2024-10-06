import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/wPhieuThu/pt_taophieuthu.dart';
import 'package:ql_khach/widgets/widgets.dart';

final sortColumnPVD = StateProvider.autoDispose<int>((ref) => 0);
final isSortPVD = StateProvider.autoDispose<bool>((ref) => true);

class PtTableDoanhso extends ConsumerStatefulWidget {
  PtTableDoanhso({super.key});

  @override
  PtTableDoanhsoState createState() => PtTableDoanhsoState();
}

class PtTableDoanhsoState extends ConsumerState<PtTableDoanhso> {

  final txtDsThang = TextEditingController();

  void _onRefresh(WidgetRef ref) {
    ref.refresh(phieuThuProvider);
    ref.refresh(filterDoanSoPVD);
    ref.refresh(sortColumnPVD);
    ref.refresh(isSortPVD);
    txtDsThang.text = DateFormat('MM/yyyy').format(DateTime.now());

  }

  @override
  void initState() {
    // TODO: implement initState
    txtDsThang.text = DateFormat('MM/yyyy').format(DateTime.now());
    super.initState();
  }


  void _onFilter(WidgetRef ref) {
    final wFilter = ref.watch(filterDoanSoPVD);
    final wDoanhSoCopy = ref.watch(ptDoanhSoCopyPVD);
    final rDoanhSoCopy = ref.read(ptDoanhSoCopyPVD.notifier);

    rDoanhSoCopy.state = wDoanhSoCopy.where((e) {
      if (wFilter.tenMoRong == 'All') wFilter.tenMoRong = null;
      bool phieu = wFilter.phieu == null || wFilter.phieu == e.id.toString();
      bool maHD =
          wFilter.maHD == null || wFilter.maHD == e.hopDongID.toString();
      bool ngayThu =
          wFilter.ngayThu == null || wFilter.ngayThu == Helper.dMy(e.ngayThu);
      bool thang = wFilter.thang == null || wFilter.thang == Helper.My(e.thang);
      bool tenMoRong =
          wFilter.tenMoRong == null || wFilter.tenMoRong == e.tenMoRong;
      bool nguoiThu =
          wFilter.nguoiThu == null || wFilter.nguoiThu == e.nguoiThu;
      bool soTien =
          wFilter.soTien == null || wFilter.soTien == Helper.formatNum(e.soTien);
      return phieu && maHD && ngayThu && thang && tenMoRong && nguoiThu && soTien;
    }).toList();
  }

  _itemCenter(String val) => Align(
    alignment: Alignment.center,
    child: Text(val),
  );

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Text(text),
    );
  }



  void _onShowAddPhieuThu(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            child: PtTaophieuthu(),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorMain = context.colorScheme.primary;
    final wDsBase = ref.watch(ptDoanhSoPVD);
    final wDoanhSo = ref.watch(ptDoanhSoCopyPVD);

    final tongDS = wDoanhSo.fold(0, (a, b) => a + b.soTien.toInt());
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // bottomSheet: Text('Hello'),
        bottomNavigationBar: SizedBox(
          height: 40,
          child: ColoredBox(
            color: colorMain,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  WtextButton(
                    text: 'Tạo phiếu thu',
                    onPressed: () => _onShowAddPhieuThu(context),
                    color: Colors.white,
                  ),
                  WtextButton(
                    text: 'Refresh',
                    onPressed: () => _onRefresh(ref),
                    color: Colors.white,
                  ),
                  const Spacer(),
                  Text(
                    'Tổng: ',
                    style: textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                  Expanded(
                    child: Wtextfield(
                      // width: 150,
                      style: textTheme.titleSmall,
                      readOnly: true,
                      controller: TextEditingController(
                        text: Helper.formatNum(tongDS.toDouble()),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Text('Doanh số tháng: '),
                Wtextfield(
                  width: 150,
                  controller: txtDsThang,
                  suffixIcon: FilledButton(
                    onPressed: () {
                      List lstThang = txtDsThang.text.split('/');
                      ref.refresh(filterDoanSoPVD);
                      ref.read(ptDoanhSoCopyPVD.notifier).state = wDsBase.where((e)=>e.dsThang=="${lstThang.last}-${lstThang.first}").toList();
                      // ref.read(phieuThuProvider.notifier).onGetPhieuThu(
                      //     thang: "${lstThang.last}-${lstThang.first}");
                    },
                    child: const Text('ok'),
                  ),
                )
              ],
            ),
            const Gap(5),
            Expanded(
                child: DataTable2(
                  minWidth: 1100,
                  fixedTopRows: 2,
                  border: TableBorder.all(color: colorMain, width: .5),
                  headingTextStyle: textTheme.titleSmall!
                      .copyWith(fontSize: 12, color: Colors.blue.shade900),
                  dataTextStyle: textTheme.bodySmall!.copyWith(fontSize: 12),
                  headingRowHeight: 25,
                  dataRowHeight: 25,
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  sortColumnIndex: ref.watch(sortColumnPVD),
                  sortAscending: ref.watch(isSortPVD),
                  headingRowColor:
                  WidgetStatePropertyAll(colorMain.withOpacity(.2)),
                  empty: Center(
                      child: Text(
                        'No data',
                        style: textTheme.titleMedium!.copyWith(
                            color: colorMain),
                      )),
                  columns: [
                    const DataColumn2(label: Text(''), fixedWidth: 30),
                    DataColumn2(
                        label: _title('Phieu'),
                        fixedWidth: 60,
                        onSort: (i, t) {
                          ref
                              .read(sortColumnPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortPVD)) {
                            wDoanhSo.sort((a, b) => b.id!.compareTo(a.id!));
                          } else {
                            wDoanhSo.sort((a, b) => a.id!.compareTo(b.id!));
                          }
                          ref
                              .read(isSortPVD.notifier)
                              .state =
                          !ref.watch(isSortPVD);
                        }),
                    DataColumn2(
                        label: _title('MaHD'),
                        fixedWidth: 80,
                        onSort: (i, t) {
                          ref
                              .read(sortColumnPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortPVD)) {
                            wDoanhSo
                                .sort((a, b) =>
                                b.hopDongID.compareTo(a.hopDongID));
                          } else {
                            wDoanhSo
                                .sort((a, b) =>
                                a.hopDongID.compareTo(b.hopDongID));
                          }
                          ref
                              .read(isSortPVD.notifier)
                              .state =
                          !ref.watch(isSortPVD);
                        }),
                    DataColumn2(
                        label: _title('Ngày thu'),
                        fixedWidth: 120,
                        onSort: (i, t) {
                          ref
                              .read(sortColumnPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortPVD)) {
                            wDoanhSo
                                .sort((a, b) =>
                                b.ngayThu!.compareTo(a.ngayThu!));
                          } else {
                            wDoanhSo
                                .sort((a, b) =>
                                a.ngayThu!.compareTo(b.ngayThu!));
                          }
                          ref
                              .read(isSortPVD.notifier)
                              .state =
                          !ref.watch(isSortPVD);
                        }),
                    DataColumn2(
                        label: _title(
                          'Tên mở rộng',
                        ),
                        fixedWidth: 100),
                    DataColumn2(label: _title('Người thu'), fixedWidth: 150),
                    DataColumn2(label: _title('Người nộp'),fixedWidth: 150),
                    DataColumn2(label: _title('Nội dung')),
                    DataColumn2(label: _title('DSTháng'),fixedWidth: 100),
                    DataColumn2(
                        label: _title('Tháng'),
                        fixedWidth: 100,
                        onSort: (i, t) {
                          ref
                              .read(sortColumnPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortPVD)) {
                            wDoanhSo.sort((a, b) => b.thang.compareTo(a.thang));
                          } else {
                            wDoanhSo.sort((a, b) => a.thang.compareTo(b.thang));
                          }
                          ref
                              .read(isSortPVD.notifier)
                              .state =
                          !ref.watch(isSortPVD);
                        }),
                    DataColumn2(
                        label: _title('Số tiền'),
                        numeric: true,
                        fixedWidth: 80,
                        onSort: (i, t) {
                          ref
                              .read(sortColumnPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortPVD)) {
                            wDoanhSo.sort((a, b) =>
                                b.soTien.compareTo(a.soTien));
                          } else {
                            wDoanhSo.sort((a, b) =>
                                a.soTien.compareTo(b.soTien));
                          }
                          ref
                              .read(isSortPVD.notifier)
                              .state =
                          !ref.watch(isSortPVD);
                        }),
                    // const DataColumn2(label: Text(''), fixedWidth: 30),
                  ],
                  rows: _rows(wDoanhSo, ref, context),
                ))
          ],
        ),
      ),
    );
  }
  List<DataRow2> _rows(List<Phieuthu> pt, WidgetRef ref, BuildContext context) {
    List<DataRow2> row = [];
    final wFilter = ref.watch(filterDoanSoPVD);
    final rFilter = ref.read(filterDoanSoPVD.notifier);

    final cbbPhieu = pt.map((e) => e.id).toSet().toList();
    final cbbMaHD = pt.map((e) => e.hopDongID).toSet().toList();
    final cbbNgayThu = pt.map((e) => Helper.dMy(e.ngayThu)).toSet().toList();
    final cbbThang = pt.map((e) => Helper.My(e.thang)).toSet().toList();
    final cbbTenMoRong = pt.map((e) => e.tenMoRong).toSet().toList();
    final cbbNguoiThu = pt.map((e) => e.nguoiThu).toSet().toList();
    final cbbSoTien = pt.map((e) => e.soTien).toSet().toList();
    cbbPhieu.sort();
    cbbMaHD.sort();
    cbbThang.sort();
    cbbTenMoRong.sort();
    cbbNgayThu.sort();
    cbbSoTien.sort();
    row.add(DataRow2(cells: [
      const DataCell(SizedBox()),
      DataCell(
        Wdropdown(
          // data: [DropdownItem(value: '', title: ''), ...cbbPhieu],
          data: cbbPhieu.map((e)=>DropdownItem(value: e.toString(), title: e.toString())).toList(),
          selected: wFilter.phieu,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setPhieu = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(
            //   value: '',
            //   title: '',
            // ),
            ...cbbMaHD.map(
                    (e) => DropdownItem(value: e.toString(), title: e.toString()))
          ],
          selected: wFilter.maHD,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setMaHD = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(value: '', title: ''),
            ...cbbNgayThu.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.ngayThu,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setNgayThu = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(value: 'All', title: 'All'),
            ...cbbTenMoRong.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.tenMoRong,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setTenMoRong = val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(value: '', title: ''),
            ...cbbNguoiThu.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.nguoiThu,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setNguoiThu = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(value: '', title: ''),
            ...cbbThang.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.thang,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setThang = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            ...cbbSoTien.map((e) => DropdownItem(value: Helper.formatNum(e), title: Helper.formatNum(e)))
          ],
          selected: wFilter.soTien,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setSoTien = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      // const DataCell(SizedBox()),
    ]));

    row.addAll(List.generate(
      pt.length,
          (i) {
        final data = pt[i];
        return DataRow2(
            color: i % 2 != 0
                ? WidgetStatePropertyAll(
                context.colorScheme.primary.withOpacity(.05))
                : null,
            cells: [
              DataCell(_itemCenter("${i + 1}")),
              DataCell(_itemCenter(data.id.toString())),
              DataCell(_itemCenter(data.hopDongID.toString())),
              DataCell(_title(Helper.dMy(data.ngayThu))),
              DataCell(_title(data.tenMoRong)),
              DataCell(_title(data.nguoiThu)),
              DataCell(_title(data.nguoiNop)),
              DataCell(_title(data.noiDung)),
              DataCell(_title(Helper.My(data.dsThang))),
              DataCell(_title(Helper.My(data.thang))),
              DataCell(_title(Helper.formatNum(data.soTien))),
            ]);
      },
    ));
    return row;
  }
}


final filterDoanSoPVD = ChangeNotifierProvider.autoDispose<FilterDoanSo>((ref) {
  return FilterDoanSo();
});

class FilterDoanSo extends ChangeNotifier {
  String? phieu;
  String? maHD;
  String? ngayThu;
  String? thang;
  String? tenMoRong;
  String? nguoiThu;
  String? soTien;

  set setPhieu(String? val) {
    phieu = val;
    notifyListeners();
  }

  set setMaHD(String? val) {
    maHD = val;
    notifyListeners();
  }

  set setNgayThu(String? val) {
    ngayThu = val;
    notifyListeners();
  }

  set setThang(String? val) {
    thang = val;
    notifyListeners();
  }

  set setTenMoRong(String? val) {
    tenMoRong = val;
    notifyListeners();
  }

  set setNguoiThu(String? val) {
    nguoiThu = val;
    notifyListeners();
  }
  set setSoTien(String? val) {
    soTien = val;
    notifyListeners();
  }
}
