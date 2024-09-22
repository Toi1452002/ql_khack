import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/app/app_theme.dart';
import 'package:ql_khach/config/config.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ql_khach/data/data.dart';

import '../providers/providers.dart';

class App extends ConsumerWidget {
  const App({super.key});

  void _onBuilding(WidgetRef ref) async{
    await ref.read(hoaHongProvider.notifier).onGetHoaHong(ref);
    // ref.read(lstHoaHongPVD.notifier).state = data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _onBuilding(ref);
    return MaterialApp.router(
      theme: ref.watch(themeDataProvider),
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const[
         Locale('vi',''),
      ],
      builder: FlutterSmartDialog.init(),
    );
  }
}