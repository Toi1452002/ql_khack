import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/extension.dart';

class Vhome extends ConsumerStatefulWidget {
  const Vhome({super.key});

  @override
  VhomeState createState() => VhomeState();
}

class VhomeState extends ConsumerState<Vhome> {
  @override
  void initState() {
    // TODO: implement initState
    final user = ref.read(userProvider);
    ref.read(hoaHongProvider.notifier).onGetHoaHong(ref, user!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      // body: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: Wrap(
      //
      //     runSpacing: 20,
      //     spacing: 20,
      //     children: [
      //       ClayContainer(
      //         color: context.colorScheme.primary,
      //         // emboss: true,
      //         height: 150,
      //         width: 300,
      //         // depth: 40,
      //         // spread: 40,
      //       ),
      //       ClayContainer(
      //         color: context.colorScheme.primary,
      //         // emboss: true,
      //         width: 300,
      //         height: 150,
      //
      //         // depth: 40,
      //         // spread: 40,
      //       ),
      //       ClayContainer(
      //         color: context.colorScheme.primary,
      //         // emboss: true,
      //         height: 150,
      //         width: 300,
      //         // depth: 40,
      //         // spread: 40,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
