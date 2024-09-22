import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/user/user_state.dart';


class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserInit());
  final _userData = UserData();
  Future<void> onLogin(String username, String password) async{
    state = UserLoading();
    try{
      final rsp = await _userData.login({
        'username': username,
        'password': password
      });

      if(rsp.statusCode == 200){
        if(rsp.data == 'null'){
          state = UserError(message: 'Đăng nhập thất bại');
        }else{
          state = UserLogin(user: User.fromMap(jsonDecode(rsp.data)));
        }
      }else{
        state = UserError(message: 'Không thể đăng nhập');
      }
    }catch(e){
      state = UserError(message: e.toString());
    }
  }


  Future<List<User>> onGetAllUser() async{
    try{
      final rps = await _userData.getAllUser();
      if(rps.statusCode==200){
        List data = jsonDecode(rps.data);
        return data.map((e)=>User.fromMap(e)).toList();
      }else{
        return [];
      }
    }catch(e){
      throw Exception(e);
    }
  }
}