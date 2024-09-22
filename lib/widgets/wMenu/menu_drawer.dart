import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/config/config.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/widgets/wMenu/menu_item.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colorScheme.primary;
    final textStyle = context.textTheme.bodyMedium!.copyWith(color: Colors.white);
    final user = ref.watch(userProvider);
    return Drawer(
      width: 250,
      backgroundColor: color,
      child: Column(
        children: [
          ColoredBox(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text('RGB'),
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username: ${user!.username}',
                        style: textStyle,
                      ),
                      Text(
                        'Fullname: ${user.fullname}',
                        style: textStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          MenuItem(
            icon: Icons.home,
            routerName: RouterName.home,
          ),
          MenuItem(
            icon: Icons.featured_play_list_outlined,
            routerName: RouterName.khach,
          ),
          MenuItem(
            icon: Icons.event_note_outlined,
            routerName: RouterName.hopDong,
          ),
          MenuItem(
            icon: Icons.table_chart,
            routerName: RouterName.bangKePhieuThu,
          ),
          MenuItem(
            icon: Icons.currency_exchange,
            routerName: RouterName.hoaHong,
          ),
          Spacer(),
          Text('Phiên bản: ${VERSION}',style: textStyle),
        ],
      ),
    );
  }
}
