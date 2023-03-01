import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

///////////////////////////////////////////////////////////////////////////////
// provider 사용부분
// account 는 어디서 오는가? 분명히 여러값을 넣은 provider 로 형태로 오지 않을까? 맞다. Provider 로 데이터를 전달한다.
final authAPIProvider = Provider<AuthAPI>((ref) {
  final appWriteAccountWatch = ref.watch(appWriteAccountProvider);
  //return AuthAPI(account: appWriteAccountWatch);
  return AuthAPI();
  }
);
// 기뻐해 주세요. 드디어 Riverpod provider 를 사용하고 있습니다.  원하는 객체를 만들어서 널리 사용할 수 있도록 tree 에 올려주고 있습니다.
// 저도 Riverpod 와 같은 삶을 살겁니다.

///////////////////////////////////////////////////////////////////////////////

// Account 는 두개의 클래스가 있는데
// appWrite.dart 에서 제공하는 Account 는 Service 클래스로 Authentication 에 관련된 기능을 제공하고 (to get user account)
// models.dart 에서 제공하는 Account 는 일반적인 Account user data 클래스를 제공한다. (to access user related data)

abstract class IAuthAPI {
  // appWrite 에서 데이터가 넘어오므로 Future<Either<Account, String>> 을 사용해야 한다.
  // 그리고 데이터가 성공하면 model.Account 가 넘어온다. 맑그대로 데이터 클래스가 넘어온다는 것.
  FutureEither<model.Account> signUp(
      {required String email, required String password});
  FutureEither<model.Session> login({
    required String email, required String password});
  // 지금 로그인이 되어있는지 확인하는 거잖아.. 그냥 서버에 접근해서 내려받으면 되는거지.. 그러니깐 null 이 될 수도 있는거고..
  // FutureEither 를 쓰지 않은 이유는 FutureBuilder 가 error 를 자동으로 처리할 수 있어서이다.
  Future<model.Account?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  // 기억하자 지금 Authentication 하기 때문에 appWrite.dart 에서 제공하는 Account 를 사용해야 한다.
  // 이 객체를 사용함으로써 이제부터 AppWrite 에서 제공해주는 여러 함수를 다 사용할 수 있게 된다.
  // 상식적으로 생각해봐라. 여러가지 Account 에 대한 정보가 있을거잖아.. 그중하나가 User id 일거고..
  late Account _account;

  // AuthAPI({required Account account}) : _account = account;
  AuthAPI() {
    Client client = Client(endPoint: AppWriteConstants.endPoint);
    client.setProject(AppWriteConstants.projectId);
    client.setSelfSigned(status: true); // 개발하는 시점에만 true 라고 해야 한단다.
    _account = Account(client);

  }

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      return await _account.get(); // 너무 간단하다. 그냥 _account.get() 하면 된다.
    } on AppwriteException {
      return null;
    } catch (e) {
      return null; // 로그인이 안되었잖아.. 그러니깐 null 이지..
    }
  }

  @override
  FutureEither<model.Account> signUp(
      {required String email, required String password}) async {
    // 여기서 AppWrite 를 위한 Account 를 정보를 가지고 있는 Account 를 외부에서 받아 이제 AppWrite 에서 제공하는 함수들을 이용해서 연결을 시도한다.
    // 그리고 결국 FutureEither 를 쓰는 이유는 예측한 결과값을 제대로 핸들링 하겠다는 의미이고 그래서 left, right 를 fold 를 가지고 사용한다.
    // 특이하게 when 을 사용하지 않네.. 아마도 fold 도 AppWrite Account 에서 제공하지 않을까 싶다.
    try {
      final model.Account account = await _account.create(
          userId: 'unique()', email: email, password: password); // 혹은 ID.unique() 사용
      return right(account);
    } on AppwriteException catch (e, stackTrace){ // AppWrite 를 다루고 있으니 사실상 이거 하나만 있어도 충분하다.
      return left(Failure(message: e.message.toString(), stackTrace: stackTrace));
    }
      catch (e, stackTrace) { // 이건 모든 exception object error handling 에 대한 방법이고
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // 추후 login 에서 나오는 값을 provider 에 올려놓고 그 값의 변화를 보았으면 좋겠어..
  @override
  FutureEither<model.Session> login({required String email, required String password}) async {
    try {
      final model.Session session = await _account.createEmailSession(
          email: email, password: password); // 혹은 ID.unique() 사용
      return right(session);
    } on AppwriteException catch (e, stackTrace) { // AppWrite 를 다루고 있으니 사실상 이거 하나만 있어도 충분하다.
      return left(
          Failure(message: e.message.toString(), stackTrace: stackTrace));
    }
    catch (e, stackTrace) { // 이건 모든 exception object error handling 에 대한 방법이고
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

}
