import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/config/config.dart';
import 'package:ql_khach/data/data.dart';

class QlyUserNotifier extends AutoDisposeAsyncNotifier<List<User>> {
  final _dio = Dio();

  @override
  FutureOr<List<User>> build() async {
    return fetchData();
  }

  Future<void> addUser(User user) async {
    List<User> lstUser = state.value!;
    state = AsyncValue.data(lstUser..add(user));
    try {
      final rps = await _dio.post(
        PathServer.user,
        data: FormData.fromMap(
          PathServer.push(
            type: 'add-user',
            data: user.toMap(),
          ),
        ),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _dio.post(
        PathServer.user,
        data: FormData.fromMap(
          PathServer.push(
            type: 'update-user',
            data: user.toMap(),
          ),
        ),
      );
      reload();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateHH(int id, bool val) async {
    List<User> lstUser = state.value!;
    int index = lstUser.indexWhere((e) => e.id == id);
    lstUser[index].nhanHH = val;

    state = AsyncValue.data(lstUser);

    try {
      await _dio.post(
        PathServer.user,
        data: FormData.fromMap(
          PathServer.push(
            type: 'update-nhanHH',
            data: {'ID': id, 'NhanHH': val ? 1 : 0},
          ),
        ),
      );
      // reload();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteUser(int id) async {
    List<User> lstUser = state.value!;
    int index = lstUser.indexWhere((e) => e.id == id);

    state = AsyncValue.data(lstUser..removeAt(index));

    try {
      await _dio.post(
        PathServer.user,
        data: FormData.fromMap(
          PathServer.push(
            type: 'delete-user',
            data: {
              'ID': id,
            },
          ),
        ),
      );
      // reload();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> reload() async {
    // Đặt trạng thái là loading trước khi làm mới dữ liệu
    state = const AsyncValue.loading();

    // Sau đó cập nhật lại trạng thái bằng kết quả mới
    state = await AsyncValue.guard(() => fetchData());
  }

  Future<List<User>> fetchData() async {
    //  tải dữ liệu
    final rsp = await _dio.get(PathServer.user,
        queryParameters: PathServer.push(type: 'get-all-user'));
    List data = jsonDecode(rsp.data);
    await Future.delayed(Duration(milliseconds: 500));
    return data.map((e) => User.fromMap(e)).toList();
  }
}
