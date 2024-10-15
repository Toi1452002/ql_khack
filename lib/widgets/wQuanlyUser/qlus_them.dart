import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

class QlusThem extends ConsumerStatefulWidget {
  User? user;

  QlusThem({super.key, this.user});

  @override
  QlusThemState createState() => QlusThemState();
}

class QlusThemState extends ConsumerState<QlusThem> {
  String selectLV = '0';
  String errorText = "";
  final txtUserName = TextEditingController();
  final txtFullName = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.user != null) {
      txtUserName.text = widget.user!.username;
      txtFullName.text = widget.user!.fullname;
      txtPassword.text = widget.user!.password;
      selectLV = widget.user!.level.toString();
    }
    super.initState();
  }

  void _close() {
    Navigator.pop(context);
  }

  void _add(List<User> lstUser) {
    if (txtUserName.text.isEmpty || txtFullName.text.isEmpty) {
      setState(() {
        errorText = 'Username hoặc Fulname trống!';
      });
      return;
    }
    if (lstUser.indexWhere((e) => e.username == txtUserName.text.trim()) !=
        -1) {
      setState(() {
        errorText = 'Username đã tồn tại!';
      });
      return;
    }

    User user = User(
        username: txtUserName.text.trim(),
        password: txtPassword.text.trim(),
        fullname: txtFullName.text.trim(),
        level: selectLV.toInt,
        nhanHH: true,
        token: '');
    ref.read(qlUsersProvider.notifier).addUser(user).whenComplete(() {
      _close();
    });
  }

  void _update(List<User> lstUser) {
    if (txtUserName.text.isEmpty || txtFullName.text.isEmpty) {
      setState(() {
        errorText = 'Username hoặc Fulname trống!';
      });
      return;
    }
    if (lstUser.indexWhere((e) =>
            e.username == txtUserName.text.trim() && e.id != widget.user!.id) !=
        -1) {
      setState(() {
        errorText = 'Username đã tồn tại!';
      });
      return;
    }
    User user = User(
        id: widget.user!.id,
        username: txtUserName.text.trim(),
        password: txtPassword.text.trim(),
        fullname: txtFullName.text.trim(),
        level: selectLV.toInt,
        token: '');
    ref.read(qlUsersProvider.notifier).updateUser(user).whenComplete(() {
      _close();
    });
  }

  @override
  Widget build(BuildContext context) {
    final qluser = ref.read(qlUsersProvider).value;

    return SizedBox(
      width: 400,
      height: 340,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.colorScheme.primary,
          actions: [
            InkWell(
                onTap: () => _close(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            const Gap(5),
          ],
          elevation: 0,
          titleSpacing: 5,
          title: Text(
            'Thông tin User',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          leadingWidth: 40,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wtextfield(
                label: 'Username',
                controller: txtUserName,
                autofocus: true,
              ),
              const Gap(15),
              Wtextfield(
                label: 'FullName',
                controller: txtFullName,
              ),
              const Gap(15),
              Wtextfield(
                label: 'Password',
                controller: txtPassword,
                obscureText: true,
              ),
              const Gap(15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wdropdown(
                    label: 'Level',
                    selected: selectLV,
                    data: [
                      DropdownItem(title: '0 - Chỉ nhận hoa hồng', value: '0'),
                      DropdownItem(title: '1 - Cấp nhân viên', value: '1'),
                      DropdownItem(title: '2 - Cấp quản trị', value: '2'),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectLV = val!;
                      });
                    },
                  ),
                  const Spacer(),
                  FilledButton(
                      onPressed: () => widget.user == null
                          ? _add(qluser!)
                          : _update(qluser!),
                      child: Text(widget.user == null ? 'Thêm' : 'Sửa'))
                ],
              ),
              Text(
                errorText,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
