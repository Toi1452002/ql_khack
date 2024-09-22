import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

class Vhoahong extends ConsumerWidget {
  const Vhoahong({super.key});

  // void _onShowAdd(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           child: SizedBox(
  //             width: 800,
  //             height: 450,
  //             child: HhAdd(),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   titleSpacing: 0,
      //   toolbarHeight: 25,
      //   actionsIconTheme:
      //       IconThemeData(size: 20, color: context.colorScheme.primary),
      //   title: Row(
      //     children: [
      //       // WtextButton(
      //       //   text: 'Thêm',
      //       //   icon: Icons.add,
      //       //   onPressed: () => _onShowAdd(context),
      //       // ),
      //     ],
      //   ),
      // ),
      body: HhTable(),
    );
  }
}
