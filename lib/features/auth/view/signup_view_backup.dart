import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.md';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SignupView extends ConsumerStatefulWidget {
  static materialPageRoute() =>
      MaterialPageRoute(builder: (context) => const LoginView());

  const SignupView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  // 여기서 잘보자. appBar 인스턴스를 하나 만들었으므로 이제 이걸 build 할 때마다 계속 사용하는거다.
  // 기존처럼 계속 function 을 호출하는게 아니다.
  final appbar = UIConstants.appBar();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

  // 위의 controller 값을 넣어야지... 지금은 그냥 함수만 실행 시킨정도이다. 화면에 값을 변경하는게 아니니깐..
  void signUp() {
    // 잘봐라.. 지금 함수를 실행시키고 있다. 그러니깐 함수 실행을 위해서 read 를 사용해야지..
    ref.read(authControllerProvider.notifier).signUp(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? const LoadingPage()
        : Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // TextField1
                AuthField(
                  textEditingController: emailTextEditingController,
                  hint: 'Email',
                ),
                const SizedBox(
                  height: 25,
                ),
                // TextField2
                AuthField(
                  textEditingController: passwordTextEditingController,
                  hint: 'Password',
                  isObscured: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                // Button
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedSmallButton(
                    onTap: signUp,
                    buttonLabel: 'Done',
                    backgroundColor: Pallete.whiteColor,
                    textColor: Pallete.blackColor,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // TextSpan
                RichText(
                  text: TextSpan(
                      text: "Already have an account?",
                      style: const TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                            text: ' Login',
                            style: const TextStyle(
                                color: Pallete.blueColor, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    SignupView.materialPageRoute());
                              }),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
