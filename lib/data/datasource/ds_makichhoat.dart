import 'package:dio/dio.dart';

import '../../config/config.dart';

abstract class DsKichHoatDataType{
  static String get getDsMaKichHoat => 'get-ds-mkh';
  static String get changeMaKichHoat => 'change-mkh';
  static String get addMKH => 'add-mkh';

}

class DsMakichhoatData{
  final _dio = Dio();

  Future<Response> post(Map<String, dynamic> data, String type){
    final formData = FormData.fromMap(PathServer.push(type: type,data: data));
    return _dio.post(PathServer.dsMaKichHoat,data: formData);
  }

  Future<Response> get(String type, {Map<String, dynamic>? data}){
    return _dio.get(PathServer.dsMaKichHoat,queryParameters: PathServer.push(type: type,data: data));
  }
}