// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tweet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TweetModel _$TweetModelFromJson(Map<String, dynamic> json) {
  return _TweetModel.fromJson(json);
}

/// @nodoc
mixin _$TweetModel {
  String get text => throw _privateConstructorUsedError;
  List<String>? get hashTags => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  List<String>? get imageLinks => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  TweetType get tweetType => throw _privateConstructorUsedError;
  DateTime get tweetAt => throw _privateConstructorUsedError;
  List<String>? get likes => throw _privateConstructorUsedError;
  List<String>? get commentIds => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get retweetedBy => throw _privateConstructorUsedError;
  int? get reshareCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TweetModelCopyWith<TweetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TweetModelCopyWith<$Res> {
  factory $TweetModelCopyWith(
          TweetModel value, $Res Function(TweetModel) then) =
      _$TweetModelCopyWithImpl<$Res, TweetModel>;
  @useResult
  $Res call(
      {String text,
      List<String>? hashTags,
      String? link,
      List<String>? imageLinks,
      String uid,
      TweetType tweetType,
      DateTime tweetAt,
      List<String>? likes,
      List<String>? commentIds,
      String? id,
      String? retweetedBy,
      int? reshareCount});
}

/// @nodoc
class _$TweetModelCopyWithImpl<$Res, $Val extends TweetModel>
    implements $TweetModelCopyWith<$Res> {
  _$TweetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? hashTags = freezed,
    Object? link = freezed,
    Object? imageLinks = freezed,
    Object? uid = null,
    Object? tweetType = null,
    Object? tweetAt = null,
    Object? likes = freezed,
    Object? commentIds = freezed,
    Object? id = freezed,
    Object? retweetedBy = freezed,
    Object? reshareCount = freezed,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      hashTags: freezed == hashTags
          ? _value.hashTags
          : hashTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      imageLinks: freezed == imageLinks
          ? _value.imageLinks
          : imageLinks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      tweetType: null == tweetType
          ? _value.tweetType
          : tweetType // ignore: cast_nullable_to_non_nullable
              as TweetType,
      tweetAt: null == tweetAt
          ? _value.tweetAt
          : tweetAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      commentIds: freezed == commentIds
          ? _value.commentIds
          : commentIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      retweetedBy: freezed == retweetedBy
          ? _value.retweetedBy
          : retweetedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reshareCount: freezed == reshareCount
          ? _value.reshareCount
          : reshareCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TweetModelCopyWith<$Res>
    implements $TweetModelCopyWith<$Res> {
  factory _$$_TweetModelCopyWith(
          _$_TweetModel value, $Res Function(_$_TweetModel) then) =
      __$$_TweetModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String text,
      List<String>? hashTags,
      String? link,
      List<String>? imageLinks,
      String uid,
      TweetType tweetType,
      DateTime tweetAt,
      List<String>? likes,
      List<String>? commentIds,
      String? id,
      String? retweetedBy,
      int? reshareCount});
}

/// @nodoc
class __$$_TweetModelCopyWithImpl<$Res>
    extends _$TweetModelCopyWithImpl<$Res, _$_TweetModel>
    implements _$$_TweetModelCopyWith<$Res> {
  __$$_TweetModelCopyWithImpl(
      _$_TweetModel _value, $Res Function(_$_TweetModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? hashTags = freezed,
    Object? link = freezed,
    Object? imageLinks = freezed,
    Object? uid = null,
    Object? tweetType = null,
    Object? tweetAt = null,
    Object? likes = freezed,
    Object? commentIds = freezed,
    Object? id = freezed,
    Object? retweetedBy = freezed,
    Object? reshareCount = freezed,
  }) {
    return _then(_$_TweetModel(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      hashTags: freezed == hashTags
          ? _value._hashTags
          : hashTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      imageLinks: freezed == imageLinks
          ? _value._imageLinks
          : imageLinks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      tweetType: null == tweetType
          ? _value.tweetType
          : tweetType // ignore: cast_nullable_to_non_nullable
              as TweetType,
      tweetAt: null == tweetAt
          ? _value.tweetAt
          : tweetAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: freezed == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      commentIds: freezed == commentIds
          ? _value._commentIds
          : commentIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      retweetedBy: freezed == retweetedBy
          ? _value.retweetedBy
          : retweetedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reshareCount: freezed == reshareCount
          ? _value.reshareCount
          : reshareCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_TweetModel implements _TweetModel {
  const _$_TweetModel(
      {required this.text,
      final List<String>? hashTags,
      this.link,
      final List<String>? imageLinks,
      required this.uid,
      required this.tweetType,
      required this.tweetAt,
      final List<String>? likes,
      final List<String>? commentIds,
      this.id,
      this.retweetedBy,
      this.reshareCount})
      : _hashTags = hashTags,
        _imageLinks = imageLinks,
        _likes = likes,
        _commentIds = commentIds;

  factory _$_TweetModel.fromJson(Map<String, dynamic> json) =>
      _$$_TweetModelFromJson(json);

  @override
  final String text;
  final List<String>? _hashTags;
  @override
  List<String>? get hashTags {
    final value = _hashTags;
    if (value == null) return null;
    if (_hashTags is EqualUnmodifiableListView) return _hashTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? link;
  final List<String>? _imageLinks;
  @override
  List<String>? get imageLinks {
    final value = _imageLinks;
    if (value == null) return null;
    if (_imageLinks is EqualUnmodifiableListView) return _imageLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String uid;
  @override
  final TweetType tweetType;
  @override
  final DateTime tweetAt;
  final List<String>? _likes;
  @override
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _commentIds;
  @override
  List<String>? get commentIds {
    final value = _commentIds;
    if (value == null) return null;
    if (_commentIds is EqualUnmodifiableListView) return _commentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? id;
  @override
  final String? retweetedBy;
  @override
  final int? reshareCount;

  @override
  String toString() {
    return 'TweetModel(text: $text, hashTags: $hashTags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetAt: $tweetAt, likes: $likes, commentIds: $commentIds, id: $id, retweetedBy: $retweetedBy, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TweetModel &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._hashTags, _hashTags) &&
            (identical(other.link, link) || other.link == link) &&
            const DeepCollectionEquality()
                .equals(other._imageLinks, _imageLinks) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.tweetType, tweetType) ||
                other.tweetType == tweetType) &&
            (identical(other.tweetAt, tweetAt) || other.tweetAt == tweetAt) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality()
                .equals(other._commentIds, _commentIds) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.retweetedBy, retweetedBy) ||
                other.retweetedBy == retweetedBy) &&
            (identical(other.reshareCount, reshareCount) ||
                other.reshareCount == reshareCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      text,
      const DeepCollectionEquality().hash(_hashTags),
      link,
      const DeepCollectionEquality().hash(_imageLinks),
      uid,
      tweetType,
      tweetAt,
      const DeepCollectionEquality().hash(_likes),
      const DeepCollectionEquality().hash(_commentIds),
      id,
      retweetedBy,
      reshareCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TweetModelCopyWith<_$_TweetModel> get copyWith =>
      __$$_TweetModelCopyWithImpl<_$_TweetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TweetModelToJson(
      this,
    );
  }
}

abstract class _TweetModel implements TweetModel {
  const factory _TweetModel(
      {required final String text,
      final List<String>? hashTags,
      final String? link,
      final List<String>? imageLinks,
      required final String uid,
      required final TweetType tweetType,
      required final DateTime tweetAt,
      final List<String>? likes,
      final List<String>? commentIds,
      final String? id,
      final String? retweetedBy,
      final int? reshareCount}) = _$_TweetModel;

  factory _TweetModel.fromJson(Map<String, dynamic> json) =
      _$_TweetModel.fromJson;

  @override
  String get text;
  @override
  List<String>? get hashTags;
  @override
  String? get link;
  @override
  List<String>? get imageLinks;
  @override
  String get uid;
  @override
  TweetType get tweetType;
  @override
  DateTime get tweetAt;
  @override
  List<String>? get likes;
  @override
  List<String>? get commentIds;
  @override
  String? get id;
  @override
  String? get retweetedBy;
  @override
  int? get reshareCount;
  @override
  @JsonKey(ignore: true)
  _$$_TweetModelCopyWith<_$_TweetModel> get copyWith =>
      throw _privateConstructorUsedError;
}
