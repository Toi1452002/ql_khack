import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

final sortTinhHHPVD = StateProvider.autoDispose<int>((ref) => 4);
final isSortTinhHHPVD = StateProvider.autoDispose<bool>((ref) => true);

class PtTinhHoahong extends ConsumerStatefulWidget {
  const PtTinhHoahong({super.key});

  @override
  PtTinhHoahongState createState() => PtTinhHoahongState();
}

class PtTinhHoahongState extends ConsumerState<PtTinhHoahong> {

  // final txtDsThang = TextEditingController();

  void _onRefresh(WidgetRef ref) {
    ref.refresh(phieuThuProvider);
    ref.refresh(filterTinhHoaHongPVD);
    ref.refresh(sortTinhHHPVD);
    ref.refresh(isSortTinhHHPVD);
    // txtDsThang.text = DateFormat('MM/yyyy').format(DateTime.now());

  }

  @override
  void initState() {
    // TODO: implement initState
    // txtDsThang.text = DateFormat('MM/yyyy').format(DateTime.now());
    super.initState();
  }
  void _onShowAddHH(
      BuildContext context, WidgetRef ref, int phieuID, String thang) async {
    final user = ref.watch(userProvider);
    await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref, user!);
    List<User> lstUser =
    await ref.read(userStateProvider.notifier).onGetAllUser();
    // print(lstUser);
    ref.read(lstUserProvider.notifier).state = lstUser;

    if (!context.mounted) return;

    await showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
              child: SizedBox(
                width: 900,
                height: 500,
                child: HhAdd(
                  hoahong: Hoahong(
                      phieuThuID: phieuID,
                      userID: 0,
                      tyleHH: 0,
                      hoaHong: 0,
                      hoaHongThang: thang),
                ),
              ),
            ),
          );
        });
  }

  void _onFilter(WidgetRef ref) {
    final wFilter = ref.watch(filterTinhHoaHongPVD);
    final wTinhHHCopy = ref.watch(ptTinhHoaHongCopy);
    final rTinhHHCopy  = ref.read(ptTinhHoaHongCopy.notifier);

    rTinhHHCopy.state = wTinhHHCopy.where((e) {
      if (wFilter.tenMoRong == 'All') wFilter.tenMoRong = null;
      bool phieu = wFilter.phieu == null || wFilter.phieu == e.id.toString();

      bool maHD = wFilter.maHD == null || wFilter.maHD == e.hopDongID.toString();
      bool maSPCT =
          wFilter.maSPCT == null || wFilter.maSPCT == e.maSPCT.toString();
      bool ngayThu =
          wFilter.ngayThu == null || wFilter.ngayThu == Helper.dMy(e.ngayThu);
      bool thang = wFilter.thang == null || wFilter.thang == Helper.My(e.thang);
      bool tenMoRong =
          wFilter.tenMoRong == null || wFilter.tenMoRong == e.tenMoRong;
      bool nguoiThu =
          wFilter.nguoiThu == null || wFilter.nguoiThu == e.nguoiThu;
      bool dsThang =
          wFilter.dsThang == null || wFilter.dsThang == Helper.My(e.dsThang);
      bool soTien =
          wFilter.soTien == null || wFilter.soTien == Helper.formatNum(e.soTien);
      return phieu && maHD && ngayThu && thang && tenMoRong && nguoiThu && soTien && dsThang && maSPCT;
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



  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorMain = context.colorScheme.tertiary;
    final wTinhHH = ref.watch(ptTinhHoaHongCopy);


    final tongDS = wTinhHH.fold(0, (a, b) => a + b.soTien.toInt());
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
                  sortColumnIndex: ref.watch(sortTinhHHPVD),
                  sortAscending: ref.watch(isSortTinhHHPVD),
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
                          ref.read(sortTinhHHPVD.notifier).state = i;
                          if (ref.watch(isSortTinhHHPVD)) {
                            wTinhHH.sort((a, b) => b.id!.compareTo(a.id!));
                          } else {
                            wTinhHH.sort((a, b) => a.id!.compareTo(b.id!));
                          }
                          ref
                              .read(isSortTinhHHPVD.notifier)
                              .state = !ref.watch(isSortTinhHHPVD);
                        }),
                    DataColumn2(
                        label: _title('MaHD'),
                        fixedWidth: 80,
                        onSort: (i, t) {
                          ref
                              .read(sortTinhHHPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortTinhHHPVD)) {
                            wTinhHH
                                .sort((a, b) =>
                                b.hopDongID.compareTo(a.hopDongID));
                          } else {
                            wTinhHH
                                .sort((a, b) =>
                                a.hopDongID.compareTo(b.hopDongID));
                          }
                          ref
                              .read(isSortTinhHHPVD.notifier)
                              .state =
                          !ref.watch(isSortTinhHHPVD);
                        }),
                    DataColumn2(
                        label: _title('Ngày thu'),
                        fixedWidth: 120,
                        onSort: (i, t) {
                          ref
                              .read(sortTinhHHPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortTinhHHPVD)) {
                            wTinhHH
                                .sort((a, b) =>
                                b.ngayThu!.compareTo(a.ngayThu!));
                          } else {
                            wTinhHH
                                .sort((a, b) =>
                                a.ngayThu!.compareTo(b.ngayThu!));
                          }
                          ref
                              .read(isSortTinhHHPVD.notifier)
                              .state =
                          !ref.watch(isSortTinhHHPVD);
                        }),
                    DataColumn2(
                        label: _title(
                          'Tên mở rộng',
                        ),
                      ),
                    DataColumn2(label: _title('Người thu'), fixedWidth: 100),
                    DataColumn2(label: _title('Nội dung')),
                    DataColumn2(label: _title('DSTháng'),fixedWidth: 100),
                    DataColumn2(
                        label: _title('Tháng'),
                        fixedWidth: 100,
                        onSort: (i, t) {
                          ref
                              .read(sortTinhHHPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortTinhHHPVD)) {
                            wTinhHH.sort((a, b) => b.thang.compareTo(a.thang));
                          } else {
                            wTinhHH.sort((a, b) => a.thang.compareTo(b.thang));
                          }
                          ref
                              .read(isSortTinhHHPVD.notifier)
                              .state = !ref.watch(isSortTinhHHPVD);

                        }),
                    DataColumn2(label: _title('MaSPCT'),fixedWidth: 100),

                    DataColumn2(
                        label: _title('Số tiền'),
                        numeric: true,
                        fixedWidth: 80,
                        onSort: (i, t) {
                          ref
                              .read(sortTinhHHPVD.notifier)
                              .state = i;
                          if (ref.watch(isSortTinhHHPVD)) {
                            wTinhHH.sort((a, b) =>
                                b.soTien.compareTo(a.soTien));
                          } else {
                            wTinhHH.sort((a, b) =>
                                a.soTien.compareTo(b.soTien));
                          }
                          ref
                              .read(isSortTinhHHPVD.notifier)
                              .state =
                          !ref.watch(isSortTinhHHPVD);
                        }),
                    const DataColumn2(label: Text(''), fixedWidth: 30),
                  ],
                  rows: _rows(wTinhHH, ref, context),
                ))
          ],
        ),
      ),
    );
  }


  List<DataRow2> _rows(List<Phieuthu> pt, WidgetRef ref, BuildContext context) {
    List<DataRow2> row = [];
    final wFilter = ref.watch(filterTinhHoaHongPVD);
    final rFilter = ref.read(filterTinhHoaHongPVD.notifier);
    final wHHThangNow = ref.watch(lstHoaHongAllPVD).map((e)=>e.phieuThuID).toSet().toList();


    final cbbPhieu = pt.map((e) => e.id).toSet().toList();
    final cbbMaHD = pt.map((e) => e.hopDongID).toSet().toList();
    final cbbMaSPCT = pt.map((e) => e.maSPCT).toSet().toList();
    final cbbNgayThu = pt.map((e) => Helper.dMy(e.ngayThu)).toSet().toList();
    final cbbThang = pt.map((e) => Helper.My(e.thang)).toSet().toList();
    final cbbTenMoRong = pt.map((e) => e.tenMoRong).toSet().toList();
    final cbbNguoiThu = pt.map((e) => e.nguoiThu).toSet().toList();
    final cbbSoTien = pt.map((e) => e.soTien).toSet().toList();
    final cbbDsThang = pt.map((e) => Helper.My(e.dsThang)).toSet().toList();
    cbbPhieu.sort();
    cbbMaHD.sort();
    cbbThang.sort();
    cbbTenMoRong.sort();
    cbbNgayThu.sort();
    cbbSoTien.sort();
    cbbMaSPCT.sort();
    row.add(DataRow2(cells: [
      const DataCell(SizedBox()),
      DataCell(
        Wdropdown(
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
          width: double.infinity,
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
      // const DataCell(SizedBox()),
      DataCell(
        Wdropdown(
          data: [
            // DropdownItem(value: '', title: ''),

            ...cbbDsThang.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.dsThang,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setDsThang = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),
      DataCell(
        Wdropdown(
          data: [
            DropdownItem(value: '', title: ''),
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
            DropdownItem(value: '', title: ''),
            ...cbbMaSPCT.map((e) => DropdownItem(value: e, title: e))
          ],
          selected: wFilter.maSPCT,
          height: 25,
          search: true,
          onChanged: (val) {
            rFilter.setMaSPCT = val == '' ? null : val.toString();
            _onFilter(ref);
          },
        ),
      ),      DataCell(
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
      const DataCell(SizedBox()),
    ]));

    row.addAll(List.generate(
      pt.length, (i) {
        final data = pt[i];
        WidgetStateProperty<Color?>? color ;
        if(wHHThangNow.contains(data.id)) color = WidgetStatePropertyAll(Colors.green.withOpacity(.1));
        return DataRow2(
            color: color,
            cells: [
              DataCell(_itemCenter("${i + 1}")),
              DataCell(_itemCenter(data.id.toString())),
              DataCell(_itemCenter(data.hopDongID.toString())),
              DataCell(_title(Helper.dMy(data.ngayThu))),
              DataCell(_title(data.tenMoRong)),
              DataCell(_title(data.nguoiThu)),
              DataCell(_title(data.noiDung)),
              DataCell(_title(Helper.My(data.dsThang))),
              DataCell(_title(Helper.My(data.thang))),
              DataCell(_title(data.maSPCT)),
              DataCell(_title(Helper.formatNum(data.soTien))),
              DataCell(
                  Align(
                    alignment: Alignment.center,
                    child: Tooltip(
                      message: 'Hoa hồng',
                      child: Icon(
                        Icons.currency_exchange,
                        size: 15,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  onTap: () =>
                      _onShowAddHH(context, ref, data.id!, data.thang)),
            ]);
      },
    ));
    return row;
  }
}


final filterTinhHoaHongPVD = ChangeNotifierProvider.autoDispose<FilterTinhHH>((ref) {
  return FilterTinhHH();
});

class FilterTinhHH extends ChangeNotifier {
  String? phieu;
  String? maHD;
  String? maSPCT;
  String? ngayThu;
  String? thang;
  String? tenMoRong;
  String? nguoiThu;
  String? dsThang;
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
  set setDsThang(String? val) {
    dsThang = val;
    notifyListeners();
  }
  set setMaSPCT(String? val){
    maSPCT = val;
    notifyListeners();
  }
}
