import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/notifier/dskichhoat_notifier.dart';


final dsKichHoatProvider = StateNotifierProvider<DskichhoatNotifier, List<DsKichhoat>>((ref) {
  return DskichhoatNotifier();
});

final selectKHProvider = StateProvider<int>((ref) {
  return 0;
});