import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'khach_notifier.dart';
import 'khach_state.dart';

export 'khach_state.dart';

final khachProvider = StateNotifierProvider.autoDispose<KhachNotifier, KhachState>((ref) {
  return KhachNotifier();
});


final khachTheoDoiProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});
