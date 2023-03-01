import 'package:freezed_annotation/freezed_annotation.dart';


part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@immutable // 꼭 해주는게 좋다.
class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserModel({
    required String email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid, // AppWrite 가 자동으로 저장할 것이다.
    String? bio,
    @Default(false) bool isTwitterBlue ,
  }) = _UserModel;


  // toJson 은 자동으로 생성된다고 했지? 그렇지만 AppWrite 의 Api 를 사용할 것이기 때문에 toJson 이 필요가 없다.
  // toString 도 자동으로 생성된다고 했고..
  // == 도 자동 생성
  // copyWith 생성자도 자동으로 생성된다.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);


}
