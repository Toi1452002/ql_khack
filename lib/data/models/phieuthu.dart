import 'package:ql_khach/utils/extension.dart';

class Phieuthu{
  int? id;
  String? ngayThu;
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
  String key;
  String dsThang;
  String userNameModified;
  String dateModified;
  String maSPCT;


  Phieuthu({
    this.id,
    this.ngayThu = "",
    this.nguoiThu = '',
    required this.nguoiNop,
    this.hopDongID = 0,
    required this.soTien,
    required this.noiDung,
    required this.thang,
    this.TTTT = false,
    this.userNameCreated = '',
    this.xacNhan = false,
    this.tenMoRong = '',
    this.key = '',
    this.dsThang ='',
    this.dateModified = '',
    this.userNameModified = '',
    this.maSPCT = ''
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'NgayThu': ngayThu!.trim(),
      'NguoiThu': nguoiThu,
      'NguoiNop': nguoiNop,
      'HopDongID': hopDongID,
      'SoTien': soTien,
      'NoiDung': noiDung,
      'Thang': thang,
      'TTTT': TTTT ? 1 : 0,
      'UserNameCreated': userNameCreated,
      'Key':key,
      'DsThang':dsThang,
      'UserNameModified': userNameModified,
      'DateModified': dateModified,
    };
  }

  factory Phieuthu.fromMap(Map<String, dynamic> map) {
    return Phieuthu(
      id: map['ID'].toString().toInt,
      ngayThu: map['NgayThu'].trim()??'',
      nguoiThu: map['NguoiThu']??'',
      nguoiNop: map['NguoiNop']??'',
      hopDongID: map['MaHD'].toString().toInt,
      soTien: map['SoTien'].toString().toDouble,
      noiDung: map['NoiDung']??'',
      thang: map['Thang']??'',
      TTTT: map['TTTT'].toString().toBool,
      xacNhan: map['XacNhan'].toString().toBool,
      tenMoRong: map['TenMoRong']??'',
      key:  map['Key']??'',
      dsThang: map['DsThang']??'',
      maSPCT: map['MaSPCT']??'',
      // userNameCreated: map['UserNameCreated'],
    );
  }
}