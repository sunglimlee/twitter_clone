import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/model/notification_model.dart';

final getLatestNotificationProvider = StreamProvider<RealtimeMessage>((ref) {
  final notificationAPIProviderWatch = ref.watch(notificationAPIProvider);
  return notificationAPIProviderWatch.getLatestNotification();
});

final getNotificationDocumentProvider = FutureProvider.autoDispose.family<List<NotificationModel>, String>((ref, String uid) {
  return ref.watch(notificationControllerProvider.notifier).getNotificationDocuments(uid);
});


final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
      notificationAPI: ref.watch(notificationAPIProvider));
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({
    required NotificationAPI notificationAPI,
  })  : _notificationAPI = notificationAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
    required BuildContext context,
  }) async {
    final notificationModel = NotificationModel(text: text, postId: postId, uid: uid, notificationType: notificationType);
    final res = await _notificationAPI.createNotification(notificationModel);
    res.fold((l) {
      // print('notification 에서 에러가 발생했습니다. ${l.message.toString()}');
      showSnackBar(context, 'notification 에서 에러가 발생했습니다. ${l.message.toString()}');

    }, (r) {
      showSnackBar(context, 'Notification Model created.');
      return null;
    });
  }

  Future<List<NotificationModel>> getNotificationDocuments(String uid) async {
    try {
      final res = await _notificationAPI.getNotificationDocuments(uid);
      return res.map((e) => NotificationModel.fromJson(e.data)).toList();
    } catch (e, st) {
      rethrow;
    }
  }
}
