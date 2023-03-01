// user_api 를 만드는 목적은 User 에 관련된 모든 method 와 data 를 모아 두려고 한다.
import 'package:appwrite/appwrite.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/model/user_model.dart';

abstract class IUserAPI {
  // abstract 에는 field 가 들어갈 수 있을까? 당연히 들어갈 수 있다고 본다.

  // user 에 관련된 데이터를 저장하려고 한다.
  FutureEitherVoid saveUserData(
      UserModel userModel); // 저장하고 문제가 없으면 void 를 리턴하기 때문이다.
}

// 이말은 interface 라는 뜻이네.. 상속과 관련없이 마음대로 만들 수 있는거 알지?
/*
class UserAPI implements IUserAPI {
  @override
  FutureEitherVoid saveUserData(UserModel userModel) {
    // 이제 여기서 AppWrite 데이터베이스 가지고 오는 부분,
    // 거기에 값을 저장하는 부분 두가지로 나와야 겠지.. : 내가 원하는 UserModel 로 값을 저장하기로 하였다.
    // 당연히 return 값을 넘겨 주어야 하고..
    // api 를 보면 어떤 값이 리턴될 거라는 걸 알 수 있으니 return 값을 내가 정할 수 있게 되겠자.
    try {

    } on AppwriteException catch (e, st) {

    } catch (e, st) {

    }
  }
}
*/
