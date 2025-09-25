import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/alert.dart';
import 'package:ql_khach/utils/extension.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
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
      backgroundColor: context.theme.colorScheme.chart3,
      child: Center(
        child: OutlinedContainer(
          // emboss: true,
          padding:  const EdgeInsets.all(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              offset: Offset(-3, 3),
              blurRadius: 10,
              spreadRadius: 5
            )
          ],
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ĐĂNG NHẬP HỆ THỐNG',
                softWrap: false,
              ).large.medium,
              const Gap(30),
              WidgetCustomRow(columnWidths: {0:80},items: [
                Text('Username').medium,
                Wtextfield(
                  controller: txtUsername,
                  autofocus: true,
                )
              ]),
              const Gap(15),
              WidgetCustomRow(columnWidths: {0:80},items: [
                Text('Password').medium,
                Wtextfield(
                  onSubmitted: (val){
                    _onLogin(ref);
                  },
                  controller: txtPassword,
                  obscureText: wshowPass,
                )
              ]),
              const Gap(15),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  onPressed: ()=>_onLogin(ref),
                  child: const Text('Login'),
                ),
              )
            ],
          ),
          // depth: 30,
          // spread: 10,
        ),
      ),
    );
  }
}
