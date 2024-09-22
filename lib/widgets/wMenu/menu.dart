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
      drawer: const MenuDrawer(),
      appBar: AppBar(
        titleSpacing: 5,
        leading: InkWell(
            onTap: () => _openDrawer(ref, !menuState.isShow),
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
          InkWell(onTap: () => _onLogout(ref),child: Icon(Icons.login_outlined,color: Colors.white,size: 20,)),
          Gap(10),
          // TextButton(
          //     onPressed: () => _onLogout(ref),
              // child: Text(
              //   'Đăng xuất',
              //   style: textTheme.bodySmall!.copyWith(color: Colors.white),
              // ))
        ],
      ),
      body: Row(
        children: [
          Visibility(visible: menuState.isShow, child: MenuDrawer()),
          Expanded(child: child)
        ],
      ),
    );
  }
}
