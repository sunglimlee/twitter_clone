import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';


part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
@immutable
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String text,
    required String postId,
    String? id,
    required String uid,
    required NotificationType notificationType,
  }) = _NotificationModel;
  


  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}