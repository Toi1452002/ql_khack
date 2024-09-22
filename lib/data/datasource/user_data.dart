import 'package:dio/dio.dart';
import 'package:ql_khach/config/config.dart';

class UserData {
  final _dio = Dio();

  Future<Response> login(Map<String, dynamic> map) async {
    final formData =
        FormData.fromMap(PathServer.push(type: 'login', data: map));
    return await _dio.post(PathServer.user, data: formData);
  }

  Future<Response> getAllUser() async{
    return await _dio.get(PathServer.user,queryParameters: PathServer.push(type: 'get-all-user'));
  }
}
