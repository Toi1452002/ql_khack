import 'package:ql_khach/data/data.dart';

abstract class HopDongState{}

class HopDongInit extends HopDongState{}
class HopDongLoading extends HopDongState{}
class HopDongHasData extends HopDongState{
  final List<Hopdong> data;
   HopDongHasData({
    required this.data,
  });
}

class HopDongError extends HopDongState{
  final String message;

  HopDongError({
    required this.message,
  });
}