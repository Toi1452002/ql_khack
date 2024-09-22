import 'package:dio/dio.dart';
import 'package:ql_khach/config/config.dart';

class HopdongData {
  final _dio = Dio();

  Future<Response> getViewHopDong() async {
    return _dio.get(PathServer.hopdong,
        queryParameters: PathServer.push(type: 'get-view-hopdong'));
  }

  Future<Response> getHopDong()async{
    return _dio.get(PathServer.hopdong,
        queryParameters: PathServer.push(type: 'get-hopdong'));
  }

  Future<Response> getDSMaKichHoat(Map<String, dynamic> data)async{
    return _dio.get(PathServer.hopdong,
        queryParameters: PathServer.push(type: 'get-ma-kich-hoat',data: data));
  }
  Future<Response> insert(Map<String, dynamic> data) async{
    final formData = FormData.fromMap(PathServer.push(type: 'insert',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> updateHD(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'update-hopdong',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> giaHanHD(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'gia-han-hop-dong',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> changeMaKichHoat(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'change-ma-kich-hoat',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> changeMKHkhachCu(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'change-ma-kich-hoat-khach-cu',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }


  Future<Response> updateHieuLuc(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'update-hieu-luc',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> deleteHopDong(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'delete-hop-dong',data: data));
    return _dio.post(PathServer.hopdong,data: formData);
  }

  Future<Response> deleteSaoLuu(Map<String, dynamic> data){
    final formData = FormData.fromMap(PathServer.push(type: 'delete-saoluu',data: data));
    return _dio.post(PathServer.config,data: formData);
  }

}
