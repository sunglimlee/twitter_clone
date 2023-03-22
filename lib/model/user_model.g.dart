// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      email: json['email'] as String,
      name: json['name'] as String?,
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profilePic: json['profile_pic'] as String?,
      bannerPic: json['banner_pic'] as String?,
      uid: json['uid'] as String?,
      bio: json['bio'] as String?,
      isTwitterBlue: json['is_twitter_blue'] as bool? ?? false,
);

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
          'email': instance.email,
          'name': instance.name,
          'followers': instance.followers,
          'following': instance.following,
          'profile_pic': instance.profilePic,
          'banner_pic': instance.bannerPic,
          'uid': instance.uid,
          'bio': instance.bio,
          'is_twitter_blue': instance.isTwitterBlue,
    };