import '../../../data/data.dart';

class DsKhachState{}


class DsKhachInit extends DsKhachState{}
class DsKhachLoading extends DsKhachState{}
class DsKhachLoaded extends DsKhachState{
  List<Khach> khach;
  DsKhachLoaded({required this.khach});
}

class DsKhachSuccess extends DsKhachState{
  String message;
  DsKhachSuccess({required this.message});
}

class DsKhachError extends DsKhachState{
  String message;
  DsKhachError({required this.message});
}