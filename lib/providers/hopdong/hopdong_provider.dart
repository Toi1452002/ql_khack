import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hopdong/hopdong.dart';
import 'package:ql_khach/providers/hopdong/hopdong_notifier.dart';
import 'package:ql_khach/utils/utils.dart';

final lstHopDongProvider = StateProvider<List<Hopdong>>((ref) {
  return [];
});

final lstHopDongViewPVD = StateProvider<List<Hopdong>>((ref) {
  return [];
});


final hopdongProvider = StateNotifierProvider.autoDispose<HopdongNotifier, HopdongState>((ref) {
  return HopdongNotifier();
});

final hdTableProvider = ChangeNotifierProvider<HdTableNotifier>((ref) {
  return HdTableNotifier();
});

final hdSelectKhachPVD = StateProvider<Khach?>((ref) {
  return null;
});

final hdThoiHanPVD = StateProvider<String>((ref) {
  return '0';
});


final hdDoanhNghiepPVD = StateProvider<bool>((ref)=>false);//state checkBox Doanh nghiep
final hdHieuLucpPVD = StateProvider<bool>((ref)=>false);//state checkBox Hieu Luc
final hdKhachOffline = StateProvider.autoDispose<bool>((ref)=>false);//state checkBox Hieu Luc




final hdErrorEditPVD = StateProvider.autoDispose<String?>((ref) {
  return null; //state bao loi nhap sai khi them/sua
});


final hdMaHD = StateProvider<int?>((ref) {
  return null;
});


final hdGHThoiHanPVD = StateProvider<String>((ref)=>'0');
final hdGHNgayHetHanPVD = StateProvider<DateTime>((ref){
  return DateTime.now();
});
final hdGHThanhToanPVD = StateProvider.autoDispose<bool>((ref)=>true);


final hdDsMaKichHoatPVD = StateProvider<List<DsKichhoat>>((ref) {
  return [];
});


final hdFilterTH = StateProvider.autoDispose<String>((ref)=>'1');
final hdFilterDN = StateProvider.autoDispose<bool>((ref)=>false);

