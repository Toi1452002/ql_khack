import 'package:ql_khach/utils/extension.dart';

class DsKichhoat {
  int? id;
  int hopDongID;
  String maKichHoat;
  String seri;
  bool trangThai;
  String dateModified;

  DsKichhoat(
      {this.id,
      this.hopDongID = 0,
      this.maKichHoat = '',
      this.trangThai = false,
      this.dateModified = '',
      this.seri = ''});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'HopDongID': hopDongID,
      'MaKichHoat': maKichHoat,
      'TrangThai': trangThai,
      'DateModified': dateModified,
      'Seri': seri
    };
  }

  factory DsKichhoat.fromMap(Map<String, dynamic> map) {
    return DsKichhoat(
        id: map['ID'].toString().toInt,
        hopDongID: map['HopDongID'].toString().toInt,
        maKichHoat: map['MaKichHoat'].toString(),
        trangThai: map['TrangThai'].toString().toBool,
        dateModified: map['DateModified'] ?? '',
        seri: map['Seri'] ?? '');
  }
}
