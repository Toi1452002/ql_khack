import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hoahong/hoahong_notifier.dart';
import 'package:ql_khach/providers/hoahong/hoahong_state.dart';

export 'hoahong_state.dart';
final hoaHongProvider = StateNotifierProvider<HoahongNotifier, HoahongState>((ref) {
  return HoahongNotifier();
});


final lstHoaHongPVD = StateProvider<List<Hoahong>>((ref) {
  return [];
});


final lstHoaHongCopyPVD = StateProvider.autoDispose<List<Hoahong>>((ref) {
  return ref.watch(lstHoaHongPVD);
});