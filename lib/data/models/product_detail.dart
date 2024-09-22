import 'package:ql_khach/utils/extension.dart';

class ProductDetail{
  int id;
  int productID;
  String ma;
  String moTa;

  ProductDetail({
    required this.id,
    required this.productID,
    required this.ma,
    required this.moTa,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'ProductID': productID,
      'Ma': ma,
      'MoTa': moTa,
    };
  }

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      id: map['ID'].toString().toInt ,
      productID: map['ProductID'].toString().toInt,
      ma: map['Ma'],
      moTa: map['MoTa'],
    );
  }
}