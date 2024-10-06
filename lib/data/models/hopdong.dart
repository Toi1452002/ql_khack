import 'package:ql_khach/utils/extension.dart';

class Hopdong {
  int? id;
  int? maHD;
  int khachID;
  String ngayHetHan;
  String? ngayTruyCap;
  int? soNgayConLai;
  String tenGoi;
  String tenMoRong;
  String tenCty;
  String maKichHoat;
  String maSP;
  String maSPCT;
  int thoiHan;
  double phi;
  double thucThu;
  String moTa;
  String nguonKhach;
  bool doanhNghiep;
  String userNameCreated;
  String userNameModified;
  String dateModified;
  int daKichHoat;
  bool hieuLuc;
  String dateCreated;
  String seri;
  int khachOffline;
  Hopdong({
    this.maHD,
    this.id,
    this.khachOffline = 0,
    this.khachID = 0,
    this.moTa = '',
    this.nguonKhach = '',
    this.doanhNghiep = false,
    this.seri = '',
    this.ngayTruyCap,
    this.soNgayConLai,
    this.userNameCreated = '',
    this.userNameModified = '',
    this.dateModified = '',
    this.ngayHetHan = '',
    this.tenGoi = '',
    this.tenMoRong = '',
    this.tenCty = '',
    this.maKichHoat = '',
    this.daKichHoat = 0,
    this.dateCreated = '',
    this.hieuLuc = false,
    required this.maSP,
    required this.maSPCT,
    required this.thoiHan,
    required this.phi,
    required this.thucThu,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID':id,
      'KhachID': khachID,
      'MoTa': moTa,
      'NguonKhach':nguonKhach,
      'DN':doanhNghiep ? 1 : 0,
      'HieuLuc':hieuLuc ? 1 : 0,
      'ThoiHan':thoiHan,
      'MaSP':maSP,
      'MaSPCT':maSPCT,
      'Phi':phi,
      'ThucThu':thucThu,
      'NgayHetHan':ngayHetHan,
      'KhachOffline': khachOffline,
      'Seri': seri,
      'UserNameCreated': userNameCreated,
      'UserNameModified': userNameModified,
      'DateModified': dateModified,
    };
  }

  factory Hopdong.fromMap(Map<String, dynamic> map) {
    return Hopdong(

      id: map['ID'].toString().toInt,
      maHD: map['MaHD'].toString().toInt,
      ngayHetHan: map['NgayHetHan'] ?? '',
      tenGoi: map['TenGoi'] ?? '',
      tenMoRong: map['TenMoRong'] ?? '',
      tenCty: map['TenCty'] ?? '',
      maKichHoat: map['MaKichHoat'] ?? '',
      maSP: map['MaSP'] ?? '',
      maSPCT: map['MaSPCT'] ?? '',
      thoiHan: map['ThoiHan'].toString().toInt,
      phi: map['Phi'].toString().toDouble,
      thucThu: map['ThucThu'].toString().toDouble,
      ngayTruyCap: map['NgayTruyCap'] ?? '',
      soNgayConLai: map['Con'].toString().toInt,
      moTa: map['MoTa']??'',
      nguonKhach: map['NguonKhach']??'',
      khachID: map['KhachID'].toString().toInt,
      doanhNghiep: map['DN']==null ? false : map['DN'].toString().toBool,
      daKichHoat: map['DaKichHoat'].toString().toInt,
      hieuLuc:map['HieuLuc']==null ? false : map['HieuLuc'].toString().toBool,
      dateCreated: map['DateCreated']??'',
      dateModified: map['DateModified']??'',
      seri: map['Seri']??''
    );
  }
}
