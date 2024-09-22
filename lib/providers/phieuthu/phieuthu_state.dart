import 'package:ql_khach/data/data.dart';

abstract class PhieuThuState{}

class PhieuThuInit  extends PhieuThuState{}

class PhieuThuLoading extends PhieuThuState{}

class PhieuThuLoaded extends PhieuThuState{
  List<Phieuthu> lstPhieuThu;
  PhieuThuLoaded({required this.lstPhieuThu});
}

class PhieuThuError extends PhieuThuState{
  String message;
  PhieuThuError({required this.message});
}

class PhieuThuSuccess extends PhieuThuState{
  String message;
  PhieuThuSuccess({required this.message});
}