import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/model/user_model.dart';

// 이제 isLoading bool 값이 들어가면서 완벽하게 연결되네.. 근데 이 bool 값은 바꾸지 않을건데... 왜 굳이 stateNotifier 를 사용한 걸까????????
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authAPI: ref.watch(authAPIProvider),
        userAPI: ref.watch(userAPIProvider)));

// 여기서 기억해야 할게 만약 이걸 provider 처리하지 않는다면
// currentUser = ref.watch(authControllerProvider.notifier).currentUserAccount(); 해주면 되지.
// 근데 이걸 provider 에 올려놓으면 나중에 언제라도 사용할 수 있으니깐 좀더 편리해 진다는 거지..
final currentUserAccountProvider = FutureProvider((ref) {
  final authControllerWatch = ref.watch(authControllerProvider.notifier);
  return authControllerWatch.currentUserAccount();
});

// 이걸 꼭 provider 에다가 이렇게 올려놓고 언제나 사용 가능 하도록 해야하나?
final currentUserDetailProvider = FutureProvider((ref) {
  final currentUserIdWatch = ref.watch(currentUserAccountProvider).value!.$id;
  final getUserDetailProviderWatch = ref.watch(getUserDetailProvider(currentUserIdWatch));
  return getUserDetailProviderWatch.value;
});

// 이건 할필요가 없는데 그냥 한건데 그냥 막 Riverpod 에 올릴 수 있다.
//final a = FutureProvider((ref) => getUserDetailProvider);


// 여기서 잘보면 이 provider 는 reusable 이다. 왜냐면 uid 를 넣는거에 따라서 값이 달라지기 때문에
// 그러면 uid 를 어떻게 하면 provider 에 넣어줄 수 있을까?
// family 로 넣어줄 수 있다. 아니면 객체로.. 아니면 다른게 있었는데..
final getUserDetailProvider = FutureProvider.family<UserModel, String>((ref, String uid) {
  // StateNotifierProvider 안의 함수를 실행하기 위해서 notifier 를 사용한다.
  final authControllerWatch = ref.watch(authControllerProvider.notifier);
  //print('uid 값은 ${uid}');
  return authControllerWatch.getUserData(uid);
});

// 이걸 StateNotifier 를 상속받아서 처리하려고 하는구나... 그럼 state 가 있는 객체를 만든다는거네..
// 잘봐라.. 새로운 클래스를 만드는거다. 근데 왜 굳이 controller 디렉토리 안에다가??
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI; // 외부에서 Riverpod 에 공유되고 있는 authAPI 가 넘어올 것이다.
  final UserAPI _userAPI;

  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  // Riverpod 은 아무것도 상속 받을 필요가 없다.
  // 결과 값을 뭐로 주는지가 중요하다.

  // isLoading 을 하려고
  // build Context 가 필요한 이유는 snackbar 를 사용하기 위함이다. 계속 궁금해 지는 부분이 알다시피 일반 클래스로도 현재의 signup 을 만들 수 있는데
  // 굳이 stateNotifier 를 상속받아서 isLoading 의 state 를 구현하겠다고 한다. 외부에서 signUp 을 할 때 email, password, context 를 받는것 까지
  // 아직까지는 기존의 방법이랑 차이가 없어서 굳이 StateNotifier 를 사용하는 이유가 충분치 않다.
  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    // 지금 authAPI 가 Riverpod 상에 올라가 있다. 이름은 authAPIProvider 라는 이름으로
    // controller 에서 authAPI 를 사용하기 위해서는 여기서 내가 원하는 데이터를 정제해서 UI 에 넘겨주고 싶다는 거지.
    // 그렇다면 ref 를 사욯할 수 있어야 하는데 어떻게 사용할 수 있을까? 이게 나의 딜레마이다. 알다시피 ui 에서 watch, read, listen 을 하는게 아니라 다른 클래스가
    // 다시 이 api 를 사용하는 거다. 기존에 Riverpod 을 사용하기 전이라면 그냥 객체를 여기서 불러서 사용했는데
    // 지금은 UI ------>  controller -------> API 이렇게 하려고 하다보니깐 ref 에 대한 문데가 생기게 된다.
    // 어떤식으로 처리할까?
    state = true; // 실제 signUp 시작하는 부분
    // 이 말대로 한다면 아까 만든 provider 는 의미가 없는 거잖아. 왜냐면 api 는 사실상 controller 에서만 사용하는 거고..
    // 그러니깐 여기서는 api 를 사용하기 위한 객체를 만들어서 사용하는 것 아닐까? 근데 여기서도 여전히 Account 가 필요한데?
    // 1. AuthAPI 객체를 만들어야 하고, 내부에서 만들어야 한다고 본다.
    // 2. Account 객체를 만들던지 받아와야 하고.. ???? 이건 ref 없는데.. 그냥 집어 넣어주나???

    // 이럴수가....
    // 외부에서 이 함수를 돌려줄 때 값을 넣어주면 되는거네... 그러면 ref 가 필요가 없는거네...
    // 내가 계속 내부에서만 값을 받으려고 하니깐 그런 문제가 생겼던 거지..
    // 외부에서 실행할 때 값을 받으면 되는데... 그럼 문제가 없는데.....
    // 왜 이런 생각을 못했던 걸까???? 이렇게 함으로써 모든 Provider 의 값을 넣는게 가능해졌다.
    final Either<Failure, Account> result =
        await _authAPI.signUp(email: email, password: password);
    timerDelay(1, () {
      state = false;
    });
    state = false; // 여기서 false 가 들어가야 겠지..
    result.fold(
        (l) =>
            // signup 을 한 에러값을 보여준다.
            showSnackBar(context, l.message.toString()), (r) async {
      // signup 을 한 정상적인 값을 넘겨준다.
      // 여기서는 navigation 을 할 거고 welcome 메세지를 보여줄 건데 지금은 print 문을 실행하도록 하자.
      // 여기서 models.Account 가 넘어왔는데 사용하고 있지 않지.. 그리고 signup 을 할 때 데이터를 저장해야 하니깐
      // 여기서 데이터를 저장하는 부분을 실행해야 한다. 그러려면 userModel 을 여기서 만들어야 하고..
      // ******************************************************************************
      // 향후 여기서 데이터를 저장하는 부분을 좀더 생각해보도록 하자.
      UserModel userModel = UserModel(email: email, name: getNameFromEmail(email), followers: const [], following: const [],uid: r.$id);
      // userModel 을 저장하는 내부 함수
      final result2 = await _userAPI.saveUserData(userModel: userModel);
      result2.fold((l) => showSnackBar(context, l.message.toString()), (r) {
        showSnackBar(context, 'Account created! Please log in.');
        Navigator.push(context, LoginView.materialPageRoute());
      });
    });
  }

  void login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final Either<Failure, Session> result =
        await _authAPI.login(email: email, password: password);
    timerDelay(1, () {
      state = false;
    });
    //state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.push(context, HomeView.materialPageRoute());
    }); // userid 를 사용하도록 하자.⭐⭐⭐⭐⭐️
  }

  // 이제는 model.Account or null 이 리턴된다.
  Future<model.Account?> currentUserAccount() {
    // 이 값을 그대로 던져줘도 되고 여기서 내가 원하는 객체로 바꾸어서 던져주어도 되고..지금 필요로 하는건 말그래도 Account 와 Exception 이므로
    // 지금은 그대로 데이터를 넘겨주는게 맞는거 같다.
    return _authAPI.currentUserAccount();
  }

  // 이 함수가 다 이해되는데 한가지 usrModel 이 리턴되는데 왜 Future<UserModel> 을 리턴값으로 가져가는걸까?
  // Future 를 지워보니깐
  // Functions marked 'async' must have a return type assignable to 'Future'.
  // 이 말은 함수이기 때문에 무조건 Future 를 해주어야 한다는 거지.. 왜냐면 이 함수가 async 이니깐 나중에 값이 나올텐데.. 라는 전제가 들어 있으니깐 무조건 Future<UserModel> 이 되어야 한다.
  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    UserModel userModel = UserModel.fromJson(document.data);
    return userModel;
  }
}
