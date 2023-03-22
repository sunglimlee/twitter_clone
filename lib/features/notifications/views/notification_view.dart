import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/features/notifications/widgets/notification_card.dart';
import 'package:twitter_clone/model/notification_model.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
        ),
        body: currentUser == null
            ? const Loader()
            : ref.watch(getNotificationDocumentProvider(currentUser.uid!)).when(
                  data: (notifications) {
                    if (notifications != null) {
                      return ref.watch(getLatestNotificationProvider).when(
                            // 얘네가 바꾸기를 원하네..
                            data: (data) {
                              if (data.events.contains(
                                'databases.*.collections.${AppWriteConstants.notificationsCollection}.documents.*.create',
                              )) {
                                final latestnotif = NotificationModel.fromJson(data.payload);
                                if (latestnotif.uid == currentUser.uid) {
                                  notifications.insert(0,
                                      latestnotif);
                                }
                              }
                              // data.events.clear(); 이건 여기서 필요없지.. 왜냐면 밖에서도 되어야 하니깐..
                              return ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  final notification = notifications[index];
                                  return NotificationCard(
                                    notificationModel: notification,
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              errorMessage: error.toString(),
                            ),
                            loading: () {
                              // 맨처음에 stream 이 없으니 데이터 자체가 없는거지.. 그래서 여전히 List 를 리턴하는거고..
                              return ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  final notification = notifications[index];
                                  return NotificationCard(
                                      notificationModel: notification);
                                },
                              );
                            },
                          );
                    } else {
                      // null 이면 데이터를 보여줄 필요가 없지
                      return Container();
                    }
                  },
                  error: (error, stackTrace) => ErrorText(
                    errorMessage: error.toString(),
                  ),
                  loading: () => const Loader(),
                ));
  }
}
