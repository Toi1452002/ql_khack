import '../../../data/data.dart';

abstract class DsKntdState{}

class DsKntdLoading extends DsKntdState{}
class DsKntdInit extends DsKntdState{}
class DsKntdLoaded extends DsKntdState{
  List<Khach> lstKhach;
  DsKntdLoaded({required this.lstKhach});
}

class DsKntdError extends DsKntdState{
  String message;
  DsKntdError({required this.message});
}