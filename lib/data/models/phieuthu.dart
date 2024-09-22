import 'package:ql_khach/utils/extension.dart';

class Phieuthu{
  int? id;
  String ngayThu;
  String nguoiThu;
  String nguoiNop;
  int hopDongID;
  double soTien;
  String noiDung;
  String thang;
  bool TTTT;
  bool xacNhan;
  String tenMoRong;
  String userNameCreated;

  Phieuthu({
    this.id,
    this.ngayThu = "",
    required this.nguoiThu,
    required this.nguoiNop,
    required this.hopDongID,
    required this.soTien,
    required this.noiDung,
    required this.thang,
    required this.TTTT,
    this.userNameCreated = '',
    this.xacNhan = false,
    this.tenMoRong = ''
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      // 'ngayThu': this.ngayThu,
      'NguoiThu': nguoiThu,
      'NguoiNop': nguoiNop,
      'HopDongID': hopDongID,
      'SoTien': soTien,
      'NoiDung': noiDung,
      'Thang': thang,
      'TTTT': TTTT ? 1 : 0,
      'UserNameCreated': userNameCreated,
    };
  }

  factory Phieuthu.fromMap(Map<String, dynamic> map) {
    return Phieuthu(
      id: map['ID'].toString().toInt,
      ngayThu: map['NgayThu']??'',
      nguoiThu: map['NguoiThu']??'',
      nguoiNop: map['NguoiNop']??'',
      hopDongID: map['MaHD'].toString().toInt,
      soTien: map['SoTien'].toString().toDouble,
      noiDung: map['NoiDung']??'',
      thang: map['Thang']??'',
      TTTT: map['TTTT'].toString().toBool,
      xacNhan: map['XacNhan'].toString().toBool,
      tenMoRong: map['TenMoRong']??''
      // userNameCreated: map['UserNameCreated'],
    );
  }
}