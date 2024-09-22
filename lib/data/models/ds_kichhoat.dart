import 'package:ql_khach/utils/extension.dart';

class DsKichhoat{
  int? id;
  int hopDongID;
  String maKichHoat;
  bool trangThai;
  String dateModified;

  DsKichhoat({
    this.id,
    this.hopDongID=0,
    this.maKichHoat='',
    this.trangThai=false,
   this.dateModified='',
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': this.id,
  //     'hopDongID': this.hopDongID,
  //     'maKichHoat': this.maKichHoat,
  //     'trangThai': this.trangThai,
  //     'dateModified': this.dateModified,
  //   };
  // }

  factory DsKichhoat.fromMap(Map<String, dynamic> map) {
    return DsKichhoat(
      id: map['ID'].toString().toInt,
      hopDongID: map['HopDongID'].toString().toInt,
      maKichHoat: map['MaKichHoat'].toString(),
      trangThai: map['TrangThai'].toString().toBool,
      dateModified: map['DateModified']??'',
    );
  }
}