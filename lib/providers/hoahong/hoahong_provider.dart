import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hoahong/hoahong_notifier.dart';
import 'package:ql_khach/providers/hoahong/hoahong_state.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';

export 'hoahong_state.dart';
final hoaHongProvider = StateNotifierProvider<HoahongNotifier, HoahongState>((ref) {
  return HoahongNotifier();
});


final lstHoaHongPVD = StateProvider<List<Hoahong>>((ref) {
  return [];
});

final lstHoaHongAllPVD = StateProvider<List<Hoahong>>((ref) {
  return [];
});

final lstHoaHongCopyPVD = StateProvider<List<Hoahong>>((ref) {
  return ref.watch(lstHoaHongPVD);
});

final lstHoaHongKhacPVD = FutureProvider.autoDispose<List<Hoahong>>((ref) async {
  final hhData = HoahongData();
  final rps = await hhData.get(HoaHongDataType.getAllHoaHongKhac);
  List data = jsonDecode(rps.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return data.map((e)=>Hoahong.fromMap(e)).toList();
});

final lstHoaHongUserPVD = FutureProvider.autoDispose<List<Hoahong>>((ref) async {
  final hhData = HoahongData();
  final user = ref.read(userProvider);
  final rps = await hhData.get(HoaHongDataType.getUserHoaHong);
  List data = jsonDecode(rps.data);
  List<Hoahong> hoahong = data.map((e)=>Hoahong.fromMap(e)).toList();
  if(user!.level<2){
    hoahong = hoahong.where((e)=>e.user==user.fullname).toList();
  }
  await Future.delayed(const Duration(milliseconds: 500));
  return hoahong;
});

final hhSelectThangPVD = StateProvider.autoDispose<String>((ref){
  DateTime date = DateTime.now();
  String format = DateFormat('MM/yyyy').format(date);
  return format;
});
