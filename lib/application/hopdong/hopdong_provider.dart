import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hopdong_state.dart';
import 'hopdong_notifier.dart';


export 'hopdong_state.dart';

final hopDongProvider = StateNotifierProvider.autoDispose<HopDongNotifier, HopDongState>((ref) {
  return HopDongNotifier();
});


final hopDongSubmitProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
