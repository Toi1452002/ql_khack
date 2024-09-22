import '../../data/data.dart';

abstract class HoahongState{}

class HoahongInit extends HoahongState{}

class HoahongLoading extends HoahongState{}


class HoahongLoaded extends HoahongState{
  List<Hoahong> lstHoaHong;
  HoahongLoaded({required this.lstHoaHong});
}

class HoahongError extends HoahongState{
  String message;
  HoahongError({required this.message});
}