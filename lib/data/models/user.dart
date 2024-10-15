import 'package:ql_khach/utils/extension.dart';

class User{
  int? id;
  String username;
  String password;
  String fullname;
  int level;
  String token;
  bool nhanHH;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.fullname,
    required this.level,
    required this.token,
    this.nhanHH = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'UserName': username,
      'PassWord': password,
      'FullName': fullname,
      'Level': level,
      'Token': token,
      'NhanHH':nhanHH.toString().toInt
    };
  }


  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, fullname: $fullname, level: $level, token: $token}';
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['ID'].toString().toInt,
      username: map['UserName'] ??'',
      password: map['PassWord'] ??'',
      fullname: map['FullName'] ??'',
      level: map['Level'].toString().toInt ,
      token: map['Token']??'' ,
      nhanHH: map['NhanHH'].toString().toBool
    );
  }


}