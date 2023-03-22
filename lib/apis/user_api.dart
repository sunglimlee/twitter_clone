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
  final realtime = ref.watch(appWriteRealtimeProvider);
  final client = ref.watch(appWriteClientProvider);
  return UserAPI(db: db, realtime: realtime, client: client);
});

abstract class IUserAPI {
  // abstract 에는 field 가 들어갈 수 있을까? 당연히 들어갈 수 있다고 본다.

  // user 에 관련된 데이터를 저장 하려고 한다. 여기서도 외부에서 들어왔다.
  FutureEitherVoid saveUserData(
      {required UserModel userModel}); // 저장하고 문제가 없으면 void 를 리턴하기 때문이다.
  Future<model.Document> getUserData(String uid);

  Future<List<model.Document>> searchUserByName(String name);

  FutureEitherVoid updateUserData(UserModel userModel);

  Stream<RealtimeMessage> getLatestUserProfileData();

  FutureEitherVoid followersUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

// 이말은 interface 라는 뜻이네.. 상속과 관련없이 마음대로 만들 수 있는거 알지?
class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  final Client _client;

  UserAPI({required Databases db, required Realtime realtime, required Client client}) : _db = db, _realtime = realtime, _client = client;

  @override
  Future<model.Document> getUserData(String? uid) async {
    print('in getUserData in user_api.dart : $uid');
    try {
      if (uid != null) {
        final document = await _db.getDocument(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.usersCollection,
            documentId:
                uid); // 여기에 uid 를 넣는다는건 알겠는데 앞에서 ID.unique() 를 둘 다 해주었는데 매치가 되나????
        print(
            'document in getUserData in User_api.dart : ${document.data.toString()}');
        return document;
      } else {
        throw AppwriteException("오류가 발생");
      }
    } on AppwriteException catch (e) {
      throw AppwriteException(e.message, e.code); // 여기서 오류를 던졌는데
    } catch (e) {
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
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        queries: [
          Query.search('name', name),
        ],
      );
      //print('document in getUserData in User_api.dart : ${documents.data.toString()}');
      return documents.documents;
    } on AppwriteException catch (e) {
      print(
          'List<model.Document 생성 도중 Error 발생 (searchUserByName)[user_api] ${e.message.toString()}');
      rethrow;
    } catch (e) {
      print(
          'List<model.Document 생성 도중 Error 발생 (searchUserByName)[user_api] ${e.toString()}');
      rethrow;
    }
  }

  @override
  FutureEither<model.Document> updateUserData(UserModel userModel) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: userModel.uid!,
      data: userModel.toJson());
      return right(document); // void 가 아니라 null 이다.
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }


  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    final realtime = Realtime(_client); // 이거 때문에 하루를 완전히 소모했네.. 딱 이한줄 때문에... realtime 은 공유하면 안된다.

    return realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.usersCollection}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid followersUser(UserModel user) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: user.uid!,
          data: {
            'followers' : user.followers
          });
      return right(document); // void 가 아니라 null 이다.
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }

  }

  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: user.uid!,
          data: {
            'following' : user.following
          });
      return right(document); // void 가 아니라 null 이다.
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }


  }


}






/* 원본 전체

// user_api 를 만드는 목적은 User 에 관련된 모든 method 와 data 를 모아 두려고 한다.
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/model/user_model.dart';

final userAPIProvider = Provider.autoDispose<UserAPI>((ref) {
  // family 나 다른 provider 로 들어올 수 있고
  final db = ref.watch(appWriteDatabasesProvider);
  final realtime = ref.watch(appWriteRealtimeProvider);
  return UserAPI(db: db, realtime: realtime);
});

abstract class IUserAPI {
  // abstract 에는 field 가 들어갈 수 있을까? 당연히 들어갈 수 있다고 본다.

  // user 에 관련된 데이터를 저장 하려고 한다. 여기서도 외부에서 들어왔다.
  FutureEitherVoid saveUserData(
      {required UserModel userModel}); // 저장하고 문제가 없으면 void 를 리턴하기 때문이다.
  Future<model.Document> getUserData(String uid);

  Future<List<model.Document>> searchUserByName(String name);

  FutureEitherVoid updateUserData(UserModel userModel);

  Stream<RealtimeMessage> getLatestUserProfileData();
}

// 이말은 interface 라는 뜻이네.. 상속과 관련없이 마음대로 만들 수 있는거 알지?
class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({required Databases db, required Realtime realtime}) : _db = db, _realtime = realtime;

  @override
  Future<model.Document> getUserData(String? uid) async {
    print('in getUserData in user_api.dart : $uid');
    try {
      if (uid != null) {
        final document = await _db.getDocument(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.usersCollection,
            documentId:
                uid); // 여기에 uid 를 넣는다는건 알겠는데 앞에서 ID.unique() 를 둘 다 해주었는데 매치가 되나????
        print(
            'document in getUserData in User_api.dart : ${document.data.toString()}');
        return document;
      } else {
        throw AppwriteException("오류가 발생");
      }
    } on AppwriteException catch (e) {
      throw AppwriteException(e.message, e.code); // 여기서 오류를 던졌는데
    } catch (e) {
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
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        queries: [
          Query.search('name', name),
        ],
      );
      //print('document in getUserData in User_api.dart : ${documents.data.toString()}');
      return documents.documents;
    } on AppwriteException catch (e) {
      print(
          'List<model.Document 생성 도중 Error 발생 (searchUserByName)[user_api] ${e.message.toString()}');
      rethrow;
    } catch (e) {
      print(
          'List<model.Document 생성 도중 Error 발생 (searchUserByName)[user_api] ${e.toString()}');
      rethrow;
    }
  }

  @override
  FutureEither<model.Document> updateUserData(UserModel userModel) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: userModel.uid!,
      data: userModel.toJson());
      return right(document); // void 가 아니라 null 이다.
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }


  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.usersCollection}.documents'
    ]).stream;
  }
}

 */