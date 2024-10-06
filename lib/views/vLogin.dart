import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/alert.dart';
import 'package:ql_khach/utils/extension.dart';
import 'package:ql_khach/widgets/widgets.dart';

class Vlogin extends ConsumerWidget {
  Vlogin({super.key});

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  void _onLogin(WidgetRef ref){
    ref.read(userStateProvider.notifier).onLogin(txtUsername.text, txtPassword.text);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wshowPass = ref.watch(showPasswordProvider);
    final primaryColor = context.colorScheme.primary;

    ref.listen(userStateProvider, (_, state){
      if(state is UserLoading){
        SmartDialog.showLoading();
      }
      if(state is UserLogin){
        SmartDialog.dismiss();
        ref.read(userProvider.notifier).state = state.user;

      }
      if(state is UserError){
        SmartDialog.dismiss();
        SmartAlert().showError(state.message);
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: Center(
        child: ClayContainer(
          color: primaryColor,
          // emboss: true,
          height: 240,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ĐĂNG NHẬP HỆ THỐNG',
                  softWrap: false,
                  style: context.textTheme.titleSmall!
                      .copyWith(color: Colors.white),
                ),
                const Gap(30),
                Wtextfield(
                  width: double.infinity,
                  controller: txtUsername,
                  hintText: 'Username',
                  autofocus: true,
                ),
                const Gap(15),
                Wtextfield(
                  width: double.infinity,
                  controller: txtPassword,
                  hintText: 'Password',
                  obscureText: wshowPass,
                  suffixIcon: InkWell(
                      onTap: () {
                        ref.read(showPasswordProvider.notifier).state = !wshowPass;
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 15,
                        color: !wshowPass ? Colors.green : null,
                      )),
                ),
                const Gap(15),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: ()=>_onLogin(ref),
                    child: const Text('Login'),
                  ),
                )
              ],
            ),
          ),
          // depth: 30,
          // spread: 10,
        ),
      ),
    );
  }
}
