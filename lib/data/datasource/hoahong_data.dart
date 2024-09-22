import 'package:dio/dio.dart';

import '../../config/config.dart';

abstract class HoaHongDataType{
  static String get insert => 'add-hoa-hong';
  static String get getAllHoaHong => 'get-all-hoa-hong';
  static String get updateTyLe => 'update-ty-le';
  static String get updateHoaHong => 'update-hoa-hong';
  static String get deleteHoaHong => 'delete-hoa-hong';
}

class HoahongData{
  final _dio = Dio();

  Future<Response> post(Map<String, dynamic> data, String type){
    final formData = FormData.fromMap(PathServer.push(type: type,data: data));
    return _dio.post(PathServer.hoaHong,data: formData);
  }

  Future<Response> get(String type){
    return _dio.get(PathServer.hoaHong,queryParameters: PathServer.push(type: type));
  }
}