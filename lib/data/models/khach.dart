import 'package:ql_khach/utils/utils.dart';

class Khach {
  int maKH;
  String tenGoi;
  String tenMoRong;
  String diaChi;
  String nguonLienHe;
  String tenCty;
  String maSP;
  double soTien;
  String ghiChu;
  String khuVuc;
  String dienThoai;
  String? userNameCreated;
  String? userNameModified;
  int theoDoi;
  String? dateModified;
  String? dateCreated;

  Khach(
      {this.maKH = 0,
      this.userNameCreated,
      this.userNameModified,
      this.maSP = '',
      this.soTien = 0,
      this.theoDoi = 1,
      this.dateModified,
      this.dateCreated,
      required this.tenGoi,
      required this.tenMoRong,
      required this.diaChi,
      required this.nguonLienHe,
      required this.tenCty,
      required this.ghiChu,
      required this.khuVuc,
      required this.dienThoai});

  Map<String, dynamic> toMap() {
    return {
      'ID': maKH,
      'TenGoi': tenGoi,
      'TenMoRong': tenMoRong,
      'DiaChi': diaChi,
      'NguonLienHe': nguonLienHe,
      'TenCty': tenCty,
      'UserNameCreated': userNameCreated,
      'DateModified': dateModified,
      // 'MaSP': maSP,
      // 'SoTien': soTien,
      'TheoDoi': theoDoi,
      'UserNameModified': userNameModified,
      'DienThoai': dienThoai,
      'KhuVuc': khuVuc,
      'GhiChu': ghiChu
    };
  }

  factory Khach.fromMap(Map<String, dynamic> map) {
    return Khach(
        maKH: map['MaKH'].toString() == 'null' ? map['ID'].toString().toInt : map['MaKH'].toString().toInt,
        tenGoi: map['TenGoi'] ?? '',
        tenMoRong: map['TenMoRong'] ?? '',
        diaChi: map['DiaChi'] ?? '',
        nguonLienHe: map['NguonLienHe'] ?? '',
        tenCty: map['TenCty'] ?? '',
        maSP: map['MaSP'] ?? '',
        soTien: map['SoTien'].toString().toDouble,
        ghiChu: map['GhiChu'].toString() ?? '',
        khuVuc: map['KhuVuc'] ?? '',
        theoDoi: map['TheoDoi'].toString().toInt,
        dateCreated: map['DateCreated']??'',
        dateModified: map['DateModified']??'',
        dienThoai: map['DienThoai'] ?? '');
  }
}
