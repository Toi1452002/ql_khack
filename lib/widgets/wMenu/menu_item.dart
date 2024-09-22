import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';

class MenuItem extends ConsumerWidget {
  IconData icon;
  String routerName;

  MenuItem({super.key, required this.icon, required this.routerName});

  _onTapItem(BuildContext context, WidgetRef ref) {
    ref.read(maKhachSelectProvider.notifier).state = null;
    ref.read(hdMaHD.notifier).state = null;
    context.goNamed(routerName);
    ref.read(menuProvider.notifier).changeSelect(routerName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colorScheme.primary;
    final menuState = ref.watch(menuProvider);
    final bool isSelect = menuState.select == routerName;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () => _onTapItem(context, ref),
        child: Container(
          padding: EdgeInsets.all(isSelect ? 10 : 8),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white),
              boxShadow: isSelect
                  ? [
                      const BoxShadow(
                          color: Colors.white, blurRadius: 5, spreadRadius: 2)
                    ]
                  : null),
          // color: menu.selected == title ? color.primary : null,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 17,
              ),
              const Gap(15),
              Text(
                routerName,
                style: context.textTheme.titleSmall!
                    .copyWith(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
