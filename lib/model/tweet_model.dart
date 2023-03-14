import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

@freezed
@immutable // 이거 꼭 해주어야 한다. 그래야 복사하고 하는데 문제가 없다.
class TweetModel with _$TweetModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TweetModel({
    required String text,
    List<String>? hashTags,
    String? link,
    List<String>? imageLinks,
    required String uid,
    required TweetType tweetType,
    required DateTime tweetAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
  }) = _TweetModel;

  factory TweetModel.fromJson(Map<String, dynamic> json) =>
      _$TweetModelFromJson(json);
}
