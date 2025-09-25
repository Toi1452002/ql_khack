import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/extension.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

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

  void _showInfoUser(){
    showDialog(context: context, builder: (context){
      return const mt.Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.symmetric(vertical: 50),
        child: DialogInfoUser(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.chart3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mt.InkWell(
              onTap: ()=>_showInfoUser(),
              child: OutlinedContainer(
                width: 200,
                height: 50,
                child: const Align(
                    alignment: Alignment.center, child: Text('Thông tin User',style: TextStyle(
                  fontSize: 15,
                  // color: Colors.white,
                  fontWeight: FontWeight.w500
                ),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
