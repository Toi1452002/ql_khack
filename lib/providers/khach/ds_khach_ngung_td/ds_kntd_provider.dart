import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/khach/ds_khach_ngung_td/ds_kntd_notifier.dart';
import 'package:ql_khach/providers/khach/ds_khach_ngung_td/ds_kntd_state.dart';

export 'ds_kntd_state.dart';

final dsKNTDProvider = StateNotifierProvider.autoDispose<DsKntdNotifier, DsKntdState>((ref) {
  return DsKntdNotifier();
});
