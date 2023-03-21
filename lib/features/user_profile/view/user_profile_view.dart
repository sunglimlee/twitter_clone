import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/model/user_model.dart';

class UserProfileView extends ConsumerStatefulWidget {
  final UserModel _userModel;
  const UserProfileView({Key? key, required UserModel userModel})
      : _userModel = userModel,
        super(key: key);

  static route(UserModel userModel) =>
      MaterialPageRoute(
        builder: (context) =>
            UserProfileView(
              userModel: userModel,
            ),
      );
  @override
  ConsumerState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  bool dummy = false;

  void onlySetState() {
    print ('onlySetState 가 실행되었어요.');
    setState(() {
      dummy = !dummy;
    });
  }
  RealtimeSubscription myStream() {
    final realtime = Realtime(ref.watch(appWriteClientProvider));
    var subScription = realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.usersCollection}.documents'
    ]);
    return subScription;

  }
  @override
  Widget build(BuildContext context) {
    UserModel copyOfUser = widget._userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
        data: (data) {
          if (data.events.contains(
            'databases.*.collections.${AppWriteConstants.usersCollection}.documents.*.update',
          )) {
            print('여기');
            copyOfUser = UserModel.fromJson(data.payload);
          }
          return UserProfile(userModel: copyOfUser, callback: onlySetState,);
        },
        error: (error, st) => ErrorText(
          errorMessage: error.toString(),
        ),
        loading: () {
          return UserProfile(userModel: copyOfUser, callback: onlySetState,);
        },
      ),
    );
  }
}
