import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/dskichhoat_provider.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/wHopDong/hd_add_mkh.dart';
import 'package:ql_khach/widgets/widgets.dart';

class HdDsachMkh extends ConsumerStatefulWidget {
  int maHD;

  HdDsachMkh({super.key, required this.maHD});

  @override
  ConsumerState createState() => _HdDsachMkhState();
}

class _HdDsachMkhState extends ConsumerState<HdDsachMkh> {
  @override
  void initState() {
    // TODO: implement initState
    ref.read(dsKichHoatProvider.notifier).getMaKichHoat(widget.maHD, ref);

    super.initState();
  }

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lstMKH = ref.watch(dsKichHoatProvider);
    final slect = ref.watch(selectKHProvider);
    return SizedBox(
      width: 500,
      height: 500,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.colorScheme.primary,
          title: Text(
            'Mã kích hoạt (${widget.maHD})',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          elevation: 0,
          titleSpacing: 5,
          leadingWidth: 40,
          actions: [
            InkWell(
                onTap: () => _onClose(context),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            const Gap(5),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              DsKichhoat kHoat = lstMKH.firstWhere((e) => e.id == slect);
              kHoat.dateModified = Helper.nowYmdT;
              SmartAlert().showInfo('Có chắc muốn thay đổi mã kích hoạt',
                  onConfirm: () {
                ref.read(dsKichHoatProvider.notifier).changeMKH(kHoat);
                Navigator.pop(context);
              });
            },
            child: const Text('Chấp nhận'),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 25,
                child: InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context){
                      return  Dialog(
                        child: HdAddMkh(maHD: widget.maHD,),
                      );
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: lstMKH.length,
              itemBuilder: (context, i) {
                final data = lstMKH[i];
                // if(data.trangThai){
                //   selectRadio = data.id!;
                // }
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  elevation: 10,
                  child: RadioListTile(
                    title: Text(data.maKichHoat),
                    subtitle: Text("Seri: ${data.seri}"),
                    secondary: Text(Helper.dMy(data.dateModified)),
                    value: data.id,
                    groupValue: slect,
                    onChanged: (value) {
                      ref.read(selectKHProvider.notifier).state = value!;
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
