import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

// dispose() 를 사용하기 위해서 StatefulWidget 을 사용한다.
class LoginView extends ConsumerStatefulWidget {
  static materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const LoginView());
  }

  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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
  void login() {
    // 잘봐라.. 지금 함수를 실행시키고 있다. 그러니깐 함수 실행을 위해서 read 를 사용해야지..
    ref.read(authControllerProvider.notifier).login(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider); // 꼭 기억하자. state management 를 하는 이유를
    print('isLoading : $isLoading');
    // isLoading 을 사용했으니 build 가 다시 일어난다.
    return isLoading ? const LoadingPage() : Scaffold(
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
                    onTap: login,
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
                      text: "Don't have an account?",
                      style: const TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                            text: ' Sign up',
                            style: const TextStyle(
                                color: Pallete.blueColor, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context, SignupView.materialPageRoute());
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
