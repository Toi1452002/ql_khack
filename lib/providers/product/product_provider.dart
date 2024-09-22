import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/product/product_notifier.dart';


final productProvider = ChangeNotifierProvider<ProductNotifier>((ref) {
  return ProductNotifier();
});
