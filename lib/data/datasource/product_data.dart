import 'package:dio/dio.dart';
import 'package:ql_khach/config/config.dart';

class ProductData {
  final _dio = Dio();

  Future<Response> getAllProduct() async {
    return _dio.get(PathServer.product,
        queryParameters: PathServer.push(type: 'get-all-product'));
  }

  Future<Response> getAllProductDetail() async {
    return _dio.get(PathServer.product,
        queryParameters: PathServer.push(type: 'get-all-product-detail'));
  }
}
