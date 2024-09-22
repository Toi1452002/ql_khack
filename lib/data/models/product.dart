import 'package:ql_khach/utils/extension.dart';

class Product{
  int id;
  String maSP;
  String moTa;

  Product({
    required this.id,
    required this.maSP,
    required this.moTa,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'MaSP': maSP,
      'MoTa': moTa,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['ID'].toString().toInt,
      maSP: map['MaSP'],
      moTa: map['MoTa'],
    );
  }
}