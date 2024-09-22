import 'package:ql_khach/utils/extension.dart';

class User{
  int? id;
  String username;
  String password;
  String fullname;
  int level;
  String token;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.fullname,
    required this.level,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullname': fullname,
      'level': level,
      'token': token,
    };
  }


  // @override
  // String toString() {
  //   return 'User{id: $id, username: $username, password: $password, fullname: $fullname, level: $level, token: $token}';
  // }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['ID'].toString().toInt,
      username: map['UserName'] ??'',
      password: map['PassWord'] ??'',
      fullname: map['FullName'] ??'',
      level: map['Level'].toString().toInt ,
      token: map['Token']??'' ,
    );
  }


}