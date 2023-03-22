import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/model/notification_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationModel _notificationModel;

  const NotificationCard({required NotificationModel notificationModel,
    Key? key,
  }) : _notificationModel = notificationModel, super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: (){
        switch (_notificationModel.notificationType) {
          case NotificationType.follow :
            return const Icon(Icons.person, color: Pallete.blueColor,);
          case NotificationType.like :
            return SvgPicture.asset(AssetsConstants.likeFilledIcon, color: Pallete.redColor, height: 20,);
          case NotificationType.retweet :
            return SvgPicture.asset(AssetsConstants.retweetIcon, color: Pallete.whiteColor, height: 20,);
          case NotificationType.reply :
            return const Icon(Icons.reply, color: Pallete.blueColor,);
        }
      }(),
      title: Text(_notificationModel.text),

    );
  }
}

