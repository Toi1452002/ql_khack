import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ql_khach/providers/providers.dart';
import 'router_path.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/',routes: router,redirect: (context, state){
    if(ref.watch(userProvider) == null){
      return '/login';
    }else{
      return state.path;
    }
  });
});
