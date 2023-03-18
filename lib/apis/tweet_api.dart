import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/model/tweet_model.dart';

final tweetAPIProvider = Provider<TweetAPI>((ref) {
  final db = ref.watch(appWriteDatabasesProvider);
  final realTime = ref.watch(appWriteRealtimeProvider);
  return TweetAPI(db: db, realtime: realTime);
});

abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(TweetModel tweetModel);

  Future<List<model.Document>> getTweetDocuments();

  Stream<RealtimeMessage>
      getLatestTweet(); // 전체 리스트를 다주는게 아니다. 하나의 업데이트 된 데이터만 주는 개념이다.

  FutureEither<model.Document> likeTweet(
      TweetModel tweetModel); // 그냥 TweetModel 을 전체를 다 받는구나.. 그래도 되지..

  FutureEither<model.Document> updateReshareCount(TweetModel tweetModel);

  FutureEither<List<model.Document>> getRepliedToTweet(TweetModel tweetModel);

  Future<model.Document> getDocumentByDocumentId(String documentId);

  Future<List<model.Document>> getDocumentsByUser(String uid);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<model.Document> shareTweet(TweetModel tweetModel) async {
    try {
      //print('tweetModel.toJson 여기까지 ${tweetModel.toJson()}');
      //print('tweetModel.toJson ${tweetModel.toJson()}');
      model.Document document = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetsCollection,
          documentId: ID.unique(), // 내가 맞잖아...
          data: tweetModel.toJson()); // 이것도 내가 맞았고..
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      print('AppWrite 에서 오류발생 : ${e.message.toString()}');
      return left(Failure(
          message: e.message ?? 'Some unexpected Error occurred',
          stackTrace: stackTrace));
    } catch (e, stackTrace) {
      print('catch 에서 오류발생했어요. : ${e.toString()}');
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Future<List<model.Document>> getTweetDocuments() async {
    // 데이터를 받아로려면 뭐가 필요한가?
    model.DocumentList documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        // AppWrite 의 index 에 tweetedAt 을 Attribute 로 등록해야 한다.
        Query.orderDesc('tweetedAt'),
      ],
    );
    // 이렇게 간단하게 List<Document> 를 리턴하는구나.. 왜 이렇게 되는거지????
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<model.Document> likeTweet(TweetModel tweetModel) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetsCollection,
          documentId: tweetModel.id!,
          data: {
            'likes': tweetModel.likes
            // 그럼 이말은 tweetModel 에 값을 변경해서 넘겨주어야 한다는거네..
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      // 메세지 보여주고, 아니면 print 문 찍고
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return Either.left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither<model.Document> updateReshareCount(TweetModel tweetModel) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetsCollection,
          documentId: tweetModel.id!,
          data: {
            'reshareCount': tweetModel.reshareCount
            // 그럼 이말은 tweetModel 에 값을 변경해서 넘겨주어야 한다는거네..
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      // 메세지 보여주고, 아니면 print 문 찍고
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return Either.left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  /// 특정 조건에 맞는 트윗만 불러오는 함수.
  @override
  FutureEither<List<model.Document>> getRepliedToTweet(
      TweetModel tweetModel) async {
    try {
      final document = await _db.listDocuments(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetsCollection,
          queries: [
            Query.equal('repliedTo', tweetModel.id.toString()),
            // 이걸 실수했네. id 와 매치가 되어야지..
          ]);
      return right(document.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<model.Document> getDocumentByDocumentId(String documentId) async {
    final document = await _db.getDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: documentId);
    return document;
  }

  @override
  Future<List<model.Document>> getDocumentsByUser(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        queries: [
          Query.equal('uid', uid),
          // 이걸 실수했네. id 와 매치가 되어야지..
        ]);
    return documents.documents;
  }
}
