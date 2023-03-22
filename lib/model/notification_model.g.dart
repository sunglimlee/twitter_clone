// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationModel _$$_NotificationModelFromJson(Map<String, dynamic> json) =>
    _$_NotificationModel(
      text: json['text'] as String,
      postId: json['postId'] as String,
      id: json['\$id'] as String,
      uid: json['uid'] as String,
      notificationType:
      $enumDecode(_$NotificationTypeEnumMap, (json['notificationType'] as String)),
    );

Map<String, dynamic> _$$_NotificationModelToJson(
    _$_NotificationModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'postId': instance.postId,
      //'id': instance.id,
      'uid': instance.uid,
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType]!,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.like: 'like',
  NotificationType.follow: 'follow',
  NotificationType.retweet: 'retweet',
  NotificationType.reply: 'reply',
};
