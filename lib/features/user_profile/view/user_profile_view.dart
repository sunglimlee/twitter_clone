import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/model/user_model.dart';

class UserProfileView extends ConsumerWidget {
  final UserModel _userModel;
  const UserProfileView({
    Key? key,
    required UserModel userModel
  }) : _userModel = userModel, super(key: key);

  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(userModel: userModel,),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: null,
      body: UserProfile(userModel: _userModel),
    );
  }
}