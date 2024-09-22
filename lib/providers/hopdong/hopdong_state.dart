import '../../data/data.dart';

class HopdongState{}


class HopdongInit extends HopdongState{}

class HopdongLoading extends HopdongState{}

class HopdongLoaded extends HopdongState{
  List<Hopdong> lstHopdong;
  List<Hopdong> lstHopdongCopy;
  HopdongLoaded({required this.lstHopdong, required this.lstHopdongCopy});
}

class HopdongError extends HopdongState{
  String message;
  HopdongError({required this.message});
}

class HopdongSuccess extends HopdongState{
  String message;
  HopdongSuccess({required this.message});
}