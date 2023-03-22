import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/model/notification_model.dart';

final notificationAPIProvider = Provider<NotificationAPI>((ref) {
  return NotificationAPI(db: ref.watch(appWriteDatabasesProvider), ref: ref);
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(NotificationModel notificationModel);

  Future<List<model.Document>> getNotificationDocuments(String uid);

  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Ref _ref;

  NotificationAPI({required Databases db, required Ref ref})
      : _db = db,
        _ref = ref;

  @override
  FutureEitherVoid createNotification(
      NotificationModel notificationModel) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.notificationsCollection,
          documentId: ID.unique(),
          data: notificationModel.toJson());
      return right(null); // void 가 아니라 null 이다.
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.message.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<List<model.Document>> getNotificationDocuments(String uid) async {
    try {
      // 데이터를 받아로려면 뭐가 필요한가?
      model.DocumentList documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationsCollection,
        queries: [
          // AppWrite 의 index 에 tweetedAt 을 Attribute 로 등록해야 한다.
          Query.equal('uid', uid),
        ],
      );
      // 이렇게 간단하게 List<Document> 를 리턴하는구나.. 왜 이렇게 되는거지????
      return documents.documents;
    } catch (e, st) {
      rethrow;
    }
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    final Realtime realtime = Realtime(_ref.watch(appWriteClientProvider));
    return realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.notificationsCollection}.documents'
    ]).stream;
  }
}
