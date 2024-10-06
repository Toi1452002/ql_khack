import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../providers/providers.dart';

class Vhoahong extends ConsumerStatefulWidget {
  const Vhoahong({super.key});

  @override
  VhoahongState createState() => VhoahongState();
}

class VhoahongState extends ConsumerState<Vhoahong> {
  @override
  void initState() {
    // TODO: implement initState
    final user = ref.read(userProvider);
    ref.read(hoaHongProvider.notifier).onGetHoaHong(ref, user!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HhTable(),
    );
  }
}





