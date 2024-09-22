import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/extension.dart';

class ProductNotifier extends ChangeNotifier{
  final _productData = ProductData();
  List<Product> _lstProduct = [];
  List<ProductDetail> _lstProductDetail = [];
  List<ProductDetail> _lstProductDetailCopy = [];



  String? productSelect;
  String? productDetailSelect;
  
  // String? selectMaSPCT_edit;

  List<Product> get lstProduct => _lstProduct;
  List<ProductDetail> get lstProductDetail => _lstProductDetailCopy;

  Future<void> onGetAllProduct() async{
    try{
      final rps = await _productData.getAllProduct();
      if(rps.statusCode == 200){
        List data = jsonDecode(rps.data);
        _lstProduct = data.map((e)=>Product.fromMap(e)).toList();
        notifyListeners();
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<void> onGetAllProductDetail() async{
    try{
      final rps = await _productData.getAllProductDetail();
      if(rps.statusCode == 200){
        List data = jsonDecode(rps.data);
        _lstProductDetail = data.map((e)=>ProductDetail.fromMap(e)).toList();
        notifyListeners();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  void changeProduct(String val){
    int idSelect = _lstProduct.firstWhere((e)=>e.maSP == val).id;
    _lstProductDetailCopy = _lstProductDetail.where((e)=>e.productID == idSelect).toList();
    productSelect = val;
    productDetailSelect = null;
    notifyListeners();
  }

  void changeProductDetail(String val){
    // selectMaSPCT_edit = _lstProductDetailCopy.firstWhere((e)=>e.moTa == val).ma;
    productDetailSelect = val;
    notifyListeners();
  }

}