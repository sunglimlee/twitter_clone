// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TweetModel _$$_TweetModelFromJson(Map<String, dynamic> json) {
  print("힘드네 ${json['tweetType'] as String}");
  //final aaa = (json['tweetType'] as String).toTweetTypeEnum();
  //print('$aaa'); // 이부분까지 문제 없는데???
  return _$_TweetModel(
    text: json['text'] as String,
    hashTags:
        (json['hashTags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    link: json['link'] as String?,
    imageLinks: (json['imageLinks'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    uid: json['uid'] as String,
    tweetType: (($enumDecode(
        _$TweetTypeEnumMap, (json['tweetType'] as String)))),  // 이부분 .toTweetTypeEnum() 없이 그냥 text 를 넣으면 되는거 아냐?? 밑에 _$TweetTypeEnumMap 함수를 잘봐라.. 그냥 text
    tweetAt: DateTime.parse(json['tweetedAt'] as String),
    likes: (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    commentIds: (json['commentIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    id: json['\$id'] as String?,
    // 왜냐하면 AppWrite 에서 자동생성되는 id 값이 $id 이므로 그리고 $ 를 사용하기 위해서 \ 역슬래쉬를 넣어주었다.
    reshareCount: json['reshareCount'] as int?,
  );
}

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
      //'id': instance.id, // 자동 생성 할거기 때문에 필요없다.
      'reshareCount': instance.reshareCount,
    };

const _$TweetTypeEnumMap = {
  TweetType.text: 'text',
  TweetType.image: 'image',
};
