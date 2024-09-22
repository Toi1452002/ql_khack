import '../../data/data.dart';

class UserState{}

class UserInit extends UserState{}

class UserLoading extends UserState{}

class UserLogin extends UserState{
  User user;
  UserLogin({required this.user});
}

class UserError extends UserState{
  String message;
  UserError({required this.message});
}