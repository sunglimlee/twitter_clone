// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TweetModel _$$_TweetModelFromJson(Map<String, dynamic> json) =>
    _$_TweetModel(
      text: json['text'] as String,
      hashTags: (json['hashTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      link: json['link'] as String?,
      imageLinks: (json['imageLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uid: json['uid'] as String,
          tweetType: (($enumDecode(
              _$TweetTypeEnumMap, (json['tweetType'] as String)))),  // 이부분 .toTweetTypeEnum() 없이 그냥 text 를 넣으면 되는거 아냐?? 밑에 _$TweetTypeEnumMap 함수를 잘봐라.


      tweetAt: DateTime.parse(json['tweetedAt'] as String),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      commentIds: (json['commentIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      id: json['\$id'] as String?,
      retweetedBy: json['retweetedBy'] as String?,
      reshareCount: json['reshareCount'] as int?,
      repliedTo: json['repliedTo'] as String?,
    );

Map<String, dynamic> _$$_TweetModelToJson(_$_TweetModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'hashTags': instance.hashTags,
      'link': instance.link,
      'imageLinks': instance.imageLinks,
      'uid': instance.uid,
      'tweetType': _$TweetTypeEnumMap[instance.tweetType]!,
      'tweetedAt': instance.tweetAt.toIso8601String(),
      'likes': instance.likes,
      'commentIds': instance.commentIds,
      //'id': instance.id,
      'retweetedBy': instance.retweetedBy,
      'reshareCount': instance.reshareCount,
      'repliedTo': instance.repliedTo,
    };

const _$TweetTypeEnumMap = {
  TweetType.text: 'text',
  TweetType.image: 'image',
};
