import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/wMenu/menu_drawer.dart';

class Menu extends ConsumerWidget {
  Widget child;
  Menu({super.key, required this.child});

  final _key = GlobalKey<ScaffoldState>();

  FocusNode node = FocusNode();
  _openDrawer(WidgetRef ref, bool val) {
    ref.read(menuProvider.notifier).show(val);
  }

  _onLogout(WidgetRef ref){
    node.requestFocus();
    SmartAlert().showInfo('Tiếp tục đăng xuất?',onConfirm: (){
      ref.read(userProvider.notifier).state = null;
    },focusNode: node);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colorScheme.primary;
    final textTheme = context.textTheme;
    final menuState = ref.watch(menuProvider);
    return Scaffold(
      key: _key,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        titleSpacing: 5,
        leading: InkWell(
            onTap: () => _key.currentState!.openDrawer(),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        backgroundColor: color,
        title: Text(
          menuState.select,
          style: textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        actions: [
          InkWell(onTap: () => _onLogout(ref),child: const Icon(Icons.login_outlined,color: Colors.white,size: 20,)),
          const Gap(10),
        ],
      ),
      body: child,
    );
  }
}
