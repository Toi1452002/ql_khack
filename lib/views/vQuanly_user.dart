import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

class VquanlyUser extends ConsumerWidget {
  const VquanlyUser({super.key});

  void _onEdit(BuildContext context, {User? user}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            alignment: Alignment.topCenter,
            insetPadding: const EdgeInsets.symmetric(vertical: 50),
            child: QlusThem(
              user: user,
            ),
          );
        });
  }

  void _updateHH(WidgetRef ref, int id, val) {
    ref.read(qlUsersProvider.notifier).updateHH(id, val);
  }

  void _deleteUser(User user, WidgetRef ref, BuildContext context){
    final txtPassword = TextEditingController();
    final userLogin = ref.watch(userProvider);

    if(user.nhanHH){
      SmartAlert().showInfo(
        'User đang nhận HH, không thể xóa'
      );
      return;
    }

    if(user.level>0){
      SmartAlert().showInfo(
          'Không thể xóa!'
      );
      return;
    }
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          color: Colors.yellow.shade50,
          padding: const EdgeInsets.all(10),
          width: 300,
          height: 50,
          child: Row(children: [
            Wtextfield(hintText: 'Xác minh mật khẩu để xóa',width: 200,autofocus: true,controller: txtPassword,obscureText: true,),
            const Spacer(),
            ElevatedButton(onPressed: (){
              if(txtPassword.text == userLogin!.password){
                SmartAlert().showInfo('Có chắc xóa ${user.fullname}',onConfirm: (){
                  ref.read(qlUsersProvider.notifier).deleteUser(user.id!);
                  Navigator.pop(context);
                });
              }else{
                Navigator.pop(context);
                SmartAlert().showInfo('Xóa thất bại!');
              }
            }, child: const Text('Ok'))
          ],),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qlyUser = ref.watch(qlUsersProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            WtextButton(
              onPressed: () => _onEdit(context),
              text: 'Thêm',
              icon: Icons.add,
            ),
          ],
        ),
      ),
      body: qlyUser.when(data: (data) {
        return Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: SizedBox(
            width: 490,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DataTable2(
                minWidth: 490,
                columnSpacing: 0,
                lmRatio: 0,
                horizontalMargin: 0,
                headingRowHeight: 30,
                dataRowHeight: 30,
                dividerThickness: 0,
                border: TableBorder.all(color: Colors.black, width: .6),
                columns: [
                  DataColumn2(label: _title(''), fixedWidth: 30),
                  DataColumn2(label: _title('User'), fixedWidth: 130),
                  DataColumn2(label: _title('FullName'), fixedWidth: 200),
                  DataColumn2(label: _title('NhanHH'), fixedWidth: 80),
                  DataColumn2(label: _title(''), fixedWidth: 30),
                ],
                rows: List.generate(data.length, (i) {
                  final user = data[i];
                  return DataRow2(cells: [
                    DataCell(Wtextfield(
                      controller: TextEditingController(text: "${i + 1}"),
                      readOnly: true,
                      textAlign: TextAlign.center,
                    )),
                    DataCell(
                      onDoubleTap: () => _onEdit(context, user: user),
                      Wtextfield(
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                        controller: TextEditingController(text: user.username),
                        readOnly: true,
                      ),
                    ),
                    DataCell(
                      Wtextfield(
                        controller: TextEditingController(text: user.fullname),
                        readOnly: true,
                      ),
                    ),
                    DataCell(
                      Align(
                        alignment: Alignment.center,
                        child: Checkbox(
                          value: user.nhanHH,
                          onChanged: (val) => _updateHH(ref, user.id!, val),
                        ),
                      ),
                    ),
                    DataCell(onTap: ()=>_deleteUser(user, ref, context),
                      const Align(
                          alignment: Alignment.center,
                          child: ColoredBox(
                              color: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.white,
                              ))),
                    ),
                  ]);
                }),
              ),
            ),
          ),
        );
        return const Text('Has data');
      }, error: (e, s) {
        return Text('Error: $e');
      }, loading: () {
        return Center(
            child: SpinKitRipple(
          color: context.colorScheme.primary,
          size: 100.0,
        ));
      }),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Text(text),
    );
  }
}
