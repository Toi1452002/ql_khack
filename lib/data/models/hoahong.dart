import 'package:ql_khach/utils/extension.dart';

class Hoahong {
  int? id;
  int phieuThuID;
  int userID;
  double tyleHH;
  double hoaHong;
  String hoaHongThang;
  String dateCreated;
  String userNameCreated;
  String dateModified;
  String userNameModified;
  String user;
  int maHD;
  String ngayThu;
  Hoahong({
    this.id,
    required this.phieuThuID,
    required this.userID,
    required this.tyleHH,
    required this.hoaHong,
    required this.hoaHongThang,
    this.dateCreated = '',
    this.userNameCreated = '',
    this.dateModified = '',
    this.userNameModified = '',
    this.ngayThu = '',
    this.maHD = 0,
    this.user = ''
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'PhieuThuID': phieuThuID,
      'UserID': userID,
      'TyLeHH': tyleHH,
      'HoaHong': hoaHong,
      'HoaHongThang': hoaHongThang,
      'DateCreated': dateCreated,
      'UserNameCreated': userNameCreated,
      'DateModified': dateModified,
      'UserNameModified': userNameModified,
    };
  }

  factory Hoahong.fromMap(Map<String, dynamic> map) {
    return Hoahong(
      id: map['ID'].toString().toInt,
      phieuThuID: map['MaPhieu'].toString().toInt,
      userID: map['userID'].toString().toInt,
      tyleHH: map['TyLeHH'].toString().toDouble,
      hoaHong: map['HoaHong'].toString().toDouble,
      hoaHongThang: map['HoaHongThang'] ?? '',
      user: map['User']??'',
      maHD: map['MaHD'].toString().toInt,
      ngayThu: map['NgayThu']??''
      // dateCreated: map['dateCreated'] ?? '',
      // userNameCreated: map['userNameCreated'] ?? '',
      // dateModified: map['dateModified'] ?? '',
      // userNameModified: map['userNameModified'] ?? '',
    );
  }
}
