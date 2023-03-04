import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.md';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:appwrite/models.dart' as model;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // build 함수에 async, await 를 사용해야 하는데 return 값이 widget 이니깐 어절 수 없이 FutureBuilder 를 사용해야 겠네..
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 두가지로 만들어보는데 future 로 넘어올 때, 와 AsyncData 로 넘어올 때
    // 1. AsyncData 로 넘어올 때 Riverpod 에서 제공하는 when 을 사용할 수 있다.
    final currentUserAccountWatch1 = ref.watch(currentUserAccountProvider);
    //Future<model.Account?> currentUserAccountWatch2 = ref.watch(currentUserAccountProvider.future);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: currentUserAccountWatch1.when(data: (account) {
        //print('User id is ${account!.$id.toString()}');
        if (account == null) return Container();
        return account != null ? const HomeView() : const LoginView();
      }, // 물어보자.. null 이 error 인가? 아니지!!!!
          error: (error, stackTrace) {
            return ErrorPage(
              errorMessage: error.toString(),
            );
          }, loading: () {
            return const LoadingPage();
          }),
      /*home: FutureBuilder(initialData: null, future: currentUserAccountWatch2, builder: (BuildContext context, AsyncSnapshot<model.Account?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const LoadingPage();
          default:
            if (snapshot.hasError) {
              return const ErrorPage();
            } else {
              return snapshot.data != null ? const HomeView() : const SignupView();
            }
        }
      }),*/
    );
  }
}
