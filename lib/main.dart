import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:appwrite/models.dart' as model;

import 'features/auth/controller/auth_cotroller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
        data: (user) {
          if (user != null) {
            return const HomeView();
          }
          return const LoginView();
        },
        error: (error, st) => ErrorPage(
          errorMessage: error.toString(),
        ),
        loading: () {
          //print(currentUserAccountProvider.toString());
          return const LoadingPage();},
      ),
    );
  }
}