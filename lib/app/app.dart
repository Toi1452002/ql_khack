// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/app/app_theme.dart';
import 'package:ql_khach/config/config.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadcnApp.router(
      // theme: ref.watch(themeDataProvider),
      theme: ThemeData(
        colorScheme: ColorSchemes.lightBlue(),
        radius: .3,
        typography: Typography.geist(
          small: TextStyle(fontSize: 13),
          base: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Arial'),
          medium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),

      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', ''),
      ],
      builder: FlutterSmartDialog.init(),
    );
  }
}
