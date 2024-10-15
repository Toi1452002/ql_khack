import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

class DialogInfoUser extends ConsumerStatefulWidget {
  const DialogInfoUser({super.key});

  @override
  ConsumerState createState() => _InfoUserState();
}

class _InfoUserState extends ConsumerState<DialogInfoUser> {
  final txtUserName = TextEditingController();
  final txtFullName = TextEditingController();
  final txtPassword = TextEditingController();

  bool showPass = false;
  void _close(){
    Navigator.pop(context);
  }


  void updatePassWord(){
    final user = ref.read(userProvider);
    if(txtPassword.text.trim().isEmpty){
      SmartAlert().showError('Password trống');
      return;
    }
    
    SmartAlert().showInfo('Có chắc đổi Password',onConfirm: (){
      ref.read(userStateProvider.notifier).onUpdatePassword(user!.id!, txtPassword.text.trim());
      ref.refresh(userProvider);
      _close();
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    final user = ref.read(userProvider);
    txtUserName.text = user!.username;
    txtFullName.text = user.fullname;
    txtPassword.text = user.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Wtextfield(
                label: 'Username',
                controller: txtUserName,
                autofocus: true,
                readOnly: true,
              ),
              const Gap(15),
              Wtextfield(
                label: 'FullName',
                controller: txtFullName,
                readOnly: true,
              ),
              const Gap(15),
              Wtextfield(
                label: 'Password',
                controller: txtPassword,
                obscureText: !showPass,
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPass =  !showPass;
                      });
                    },
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 15,
                      color: showPass ? Colors.green : null,
                    )),
              ),
              const Spacer(),
              FilledButton(onPressed: ()=>updatePassWord(), child: const Text('Ok'))
            ],
          ),
        ),

      ),
    );
  }
}
