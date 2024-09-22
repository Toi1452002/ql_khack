import 'package:dio/dio.dart';
import 'package:ql_khach/config/config.dart';

abstract class PhieuThuType{
    static String get insert => 'add-phieu-thu';
    static String get getPhieuThu => 'get-phieu-thu';
    static String get xacNhanTT => 'xac-nhan-tt';
    static String get xacNhanTTTT => 'xac-nhan-tttt';
}


class PhieuthuData{
  final _dio = Dio();

  Future<Response> post(Map<String, dynamic> data, String type){
    final formData = FormData.fromMap(PathServer.push(type: type,data: data));
    return _dio.post(PathServer.phieuThu,data: formData);
  }

  Future<Response> get(String type){
    return _dio.get(PathServer.phieuThu,queryParameters: PathServer.push(type: type));
  }
}