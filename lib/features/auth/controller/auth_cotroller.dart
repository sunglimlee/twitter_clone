import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/model/user_model.dart';

import '../view/signup_view.dart';


final authControllerProvider =
StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    session: ref.watch(sessionStateProvider),
  );
});

final currentUserDetailsProvider = FutureProvider.autoDispose((ref) async {

  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  //final currentUserId = ref.watch(currentUserIdProvider).value;
  print('currentUserId ${currentUserId}'); // currentUserId 존재하는데???
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  print('userDetails : ${userDetails.value?.email??"값이 존재하지 않습니다."}');
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.autoDispose.family((ref, String uid) async {
  print('uuuuuuu');
  print('in userDetaisProvider : ${uid}');
  final authController = ref.watch(authControllerProvider.notifier);
  print('authController 값 (userDetailsProvider)[auth_controller] : ${authController.toString()??"authController  값이 존재하지 않습니다."}');
  final result = await authController.getUserData(uid);
  print('result of authoController.getUserData(uid) [auth_controller] ${result.email}');
  return result;
});

final currentUserAccountProvider = FutureProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
/*
  await Future.delayed(Duration(milliseconds: 2000), () {
    return null;
  });
*/
});

final currentUserIdProvider = FutureProvider.autoDispose((ref) async {
  final authController = ref.watch(authControllerProvider.notifier); // 이제 객체 사용가능
  final result = await authController.currentUserId();
  print('current user id 값은 ${result}');
  return result;
});



class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  Session? _session;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
    Session? session,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        _session = session,
        super(false);
  // state = isLoading

  Future<model.Account?> currentUser() async {
    try {
      final result = await _authAPI.currentUserAccount();
      return result;
    } on AppwriteException catch (e)  {
      print("AppwriteException 에서 에러가 발생했습니다. ${e.message.toString()}");
      return null;
    } catch (e, stackTrace) {
      print("catch 에서 에러가 발생했습니다. ${e.toString()}");
      return null;
    }
  }

  Future<String?> currentUserId() async {
    final account = await _authAPI.currentUserAccount();
    String? uid = account?.$id??_session?.userId;
    print('uid 값은 : ${uid.toString()}');
    return uid;
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          uid: r.$id,
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel: userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created! Please login.');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  Future<Session?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    return res.fold(
          (l) {showSnackBar(context, l.message);
            return null;
          },
          (r) {
            // 여기서 session 이라는게 있다고.. 그래서 session 다루고 가지고 있자..
            print('session (login)[auth_controller] ${r.userId}');
            Navigator.push(context, HomeView.route());
            return r;
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    print('in getUserData : ${uid}');
    final document = await _userAPI.getUserData(uid);
    print('document (getUserData)[auth_controller] ${document.data.toString()}');
    final updatedUser = UserModel.fromJson(document.data);
    print('updatedUser.email (getUserData)[auth_controller] ${updatedUser.email}');
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
            (route) => false,
      );
    });
  }
}