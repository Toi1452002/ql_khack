import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/user/user_notifier.dart';
import 'package:ql_khach/providers/user/user_state.dart';

final userProvider = StateProvider<User?>((ref) {
  return null;
});

final userStateProvider = StateNotifierProvider.autoDispose<UserNotifier, UserState>((ref) {
  return UserNotifier();
});


final showPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});


final lstUserProvider = StateProvider<List<User>>((ref) {
  return [];
});
