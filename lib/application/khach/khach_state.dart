import '../../data/data.dart';

abstract class KhachState {}

class KhachInit extends KhachState {}

class KhachLoading extends KhachState {}

class KhachHasData extends KhachState {
  final List<Khach> data;

  KhachHasData({
    required this.data,
  });
}

class KhachError extends KhachState {
  final String message;

  KhachError({
    required this.message,
  });
}
