import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/providers.dart';

export 'menu_notifier.dart';

final menuProvider = ChangeNotifierProvider.autoDispose<MenuNotifier>((ref) {
  return MenuNotifier();
});
