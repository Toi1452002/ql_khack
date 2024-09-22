import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ql_khach/config/router/router.dart';
import 'package:ql_khach/views/views.dart';

import '../../widgets/widgets.dart';

final router = [
  ShellRoute(
      builder: (_, state, child) {
        return Menu(
          child: child,
        );
      },
      routes: [
        GoRoute(
            path: '/hop-dong',
            name: RouterName.hopDong,
            pageBuilder: (_, state) => buildPageTransition(
                context: _, state: state, child: VHopDong())),
        GoRoute(
            path: '/khach',
            name: RouterName.khach,
            pageBuilder: (_, state) =>
                buildPageTransition(context: _, state: state, child: Vkhach())),
        GoRoute(
            path: '/',
            name: RouterName.home,
            pageBuilder: (_, state) =>
                buildPageTransition(context: _, state: state, child: Vhome())),
        GoRoute(
            path: '/bang-ke-phieu-thu',
            name: RouterName.bangKePhieuThu,
            pageBuilder: (_, state) =>
                buildPageTransition(context: _, state: state, child: Vphieuthu())),
        GoRoute(
            path: '/hoa-hong',
            name: RouterName.hoaHong,
            pageBuilder: (_, state) =>
                buildPageTransition(context: _, state: state, child: Vhoahong())),
      ]),
  GoRoute(
      path: '/login',
      name: RouterName.login,
      pageBuilder: (_, state) =>
          buildPageTransition(context: _, state: state, child: Vlogin()))
];

CustomTransitionPage buildPageTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
