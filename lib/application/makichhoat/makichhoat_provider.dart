import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/application/makichhoat/makichhoat_notifier.dart';
import 'package:ql_khach/data/data.dart';

final maKichHoatProvider = StateNotifierProvider.autoDispose<MaKichHoatNotifier, List<DsKichhoat>>((ref) {
  return MaKichHoatNotifier();
});


final selectedMKHProvider = StateProvider<int>((ref) {
  return 0;
});
