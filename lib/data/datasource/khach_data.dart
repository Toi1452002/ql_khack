import 'package:dio/dio.dart';
import 'package:ql_khach/config/config.dart';

class KhachData {
  final _dio = Dio();

  Future<Response> getAllKhach() async {
    return _dio.get(PathServer.khach,
        queryParameters: PathServer.push(type: 'get-all'));
  }

  Future<Response> getKhachNgungTD() async {
    return _dio.get(PathServer.khach,
        queryParameters: PathServer.push(type: 'get-khach-ngung-td'));
  }

  Future<Response> insertKhach(Map<String, dynamic> data) async{
    final formData = FormData.fromMap(PathServer.push(type: 'insert',data:data ));
    return _dio.post(PathServer.khach, data: formData);
  }

  Future<Response> updateKhach(Map<String, dynamic> data) async{
    final formData = FormData.fromMap(PathServer.push(type: 'update',data:data ));
    return _dio.post(PathServer.khach, data: formData);
  }

  Future<Response> updateTheoDoi(Map<String, dynamic> data) async{
    final formData = FormData.fromMap(PathServer.push(type: 'update-theo-doi',data:data ));
    return _dio.post(PathServer.khach, data: formData);
  }

  Future<Response> deleteKhach(Map<String, dynamic> data) async{
    final formData = FormData.fromMap(PathServer.push(type: 'delete-khach',data:data ));
    return _dio.post(PathServer.khach, data: formData);
  }
}
