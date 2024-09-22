import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';

import 'ds_khach_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


export 'ds_khach_state.dart';
export 'ds_khach_table.dart';


final dsKhachProvider = StateNotifierProvider.autoDispose<DsKhachNotifier, DsKhachState>((ref) {
  return DsKhachNotifier();
});


final dsKhachTableProvider = ChangeNotifierProvider<DsKhachTable>((ref) {
  return DsKhachTable();
});


final lstKhachProvider = StateProvider<List<Khach>>((ref) {
  return [];
});


final maKhachSelectProvider = StateProvider<int?>((ref)=>null);

final khachTheoDoiProvider = StateProvider.autoDispose<bool>((ref)=>true);


final kErrorEditPVD= StateProvider.autoDispose<String?>((ref) {
  return null;
});
