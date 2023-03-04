// user_api 를 만드는 목적은 User 에 관련된 모든 method 와 data 를 모아 두려고 한다.
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/model/user_model.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  // family 나 다른 provider 로 들어올 수 있고
  final db = ref.watch(appWriteDatabasesProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  // abstract 에는 field 가 들어갈 수 있을까? 당연히 들어갈 수 있다고 본다.

  // user 에 관련된 데이터를 저장 하려고 한다. 여기서도 외부에서 들어왔다.
  FutureEitherVoid saveUserData(
      {required UserModel userModel}); // 저장하고 문제가 없으면 void 를 리턴하기 때문이다.
  Future<model.Document> getUserData(String uid);
}

// 이말은 interface 라는 뜻이네.. 상속과 관련없이 마음대로 만들 수 있는거 알지?
class UserAPI implements IUserAPI {
  final Databases _db;

  UserAPI({required Databases db}) : _db = db;

  @override
  Future<model.Document> getUserData(String uid) async {
    try {
      final document = await _db.getDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: uid); // 여기에 uid 를 넣는다는건 알겠는데 앞에서 ID.unique() 를 둘 다 해주었는데 매치가 되나????
      return document;
    } on AppwriteException catch (e, st) {
      throw AppwriteException(e.message, e.code); // 여기서 오류를 던졌는데
    } catch (e, st) {
      print('오류가 발생했습니다.');
      rethrow;
    }
  }

  @override
  FutureEitherVoid saveUserData({required UserModel userModel}) async {
    // 이제 여기서 AppWrite 데이터베이스 가지고 오는 부분,
    // 거기에 값을 저장하는 부분 두가지로 나와야 겠지.. : 내가 원하는 UserModel 로 값을 저장하기로 하였다.
    // 당연히 return 값을 넘겨 주어야 하고..
    // api 를 보면 어떤 값이 리턴될 거라는 걸 알 수 있으니 return 값을 내가 정할 수 있게 되겠자.
    try {
      // 어떻게 새로 document 를 만들 수 있나?
      // 원하는 userModel 을 외부에서 만들어서 (왜냐면 계속 바뀌니깐) 이 안에서 새롭게 createDocument 를 하였다.
      // 근데 auth 와 database/user collection/users ID.unique() 는 어떻게 연결되는거지??????
      final document = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: userModel.uid!,
          data: userModel.toJson());
      print('저장하신 userModel 의 document ID 는 ${document.$id} 입니다.');
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          message: e.message.toString() ?? 'Some unexpected error occurred',
          stackTrace: st));
    } catch (e, st) {
      return left(Failure(
          message: e.toString() ?? 'Some unexpected error occurred',
          stackTrace: st));
    }
  }
}
