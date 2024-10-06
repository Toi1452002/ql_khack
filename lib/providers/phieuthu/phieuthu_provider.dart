import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu_notifier.dart';
import 'package:ql_khach/providers/phieuthu/phieuthu_state.dart';


final phieuThuProvider = StateNotifierProvider.autoDispose<PhieuThuNotifier, PhieuThuState>((ref) {
  return PhieuThuNotifier();
});


final ptDoanhSoPVD = StateProvider<List<Phieuthu>>((ref) {
  return [];
});

final ptDoanhSoCopyPVD = StateProvider.autoDispose<List<Phieuthu>>((ref) {
  return ref.watch(ptDoanhSoPVD).where((e)=>e.dsThang==DateFormat('yyyy-MM').format(DateTime.now())).toList();
});

final ptChuaXacNhanPVD = StateProvider<List<Phieuthu>>((ref) {
  return [];
});

final ptChuaThanhToanPVD = StateProvider<List<Phieuthu>>((ref) {
  return [];
});


final ptTinhHoaHong = StateProvider<List<Phieuthu>>((ref) {
  return [];
});

final ptTinhHoaHongCopy = StateProvider.autoDispose<List<Phieuthu>>((ref) {
  return ref.watch(ptTinhHoaHong);
});