import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/model/user_model.dart';

final getDocumentByUserProvider =
    FutureProvider.autoDispose.family((ref, String uid) {
  final userProfileProviderWatch = ref.watch(userProfileProvider.notifier);
  return userProfileProviderWatch.getDocumentByUser(uid);
});

final userProfileProvider =
    StateNotifierProvider.autoDispose<UserProfileController, bool>((ref) {
  return UserProfileController(
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController: ref.watch(notificationControllerProvider.notifier),
      userAPI: ref.watch(userAPIProvider));
});

// Realtime 만 공유하지 않으면 StreamProvider 도 아무 문제 없이 작동된다.
final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final StorageAPI _storageAPI;
  final TweetAPI _tweetAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;

  UserProfileController(
      {required TweetAPI tweetAPI,
      required StorageAPI storageAPI,
        required NotificationController notificationController,
      required UserAPI userAPI})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
  _notificationController = notificationController,
        _userAPI = userAPI,
        super(false);

  Future<List<TweetModel>?> getDocumentByUser(String uid) async {
    List<model.Document> document = await _tweetAPI.getDocumentsByUser(uid);
    if (document.isEmpty) {
      return null;
    } else {
      final res = document.map((e) => TweetModel.fromJson(e.data)).toList();
      return res;
    }
  }

  void updateUserModel({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.upLoadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }
    if (profileFile != null) {
      final profileUrl = await _storageAPI.upLoadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }
    // print('🎉🎉🎉🎉🎉 update 할 user Model $userModel'); // update 되는데??
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message.toString());
    }, (r) {
      {
        showSnackBar(
          context,
          'Profile successfully updated.',
        );
        // showSnackBar(context, 'Profile successfully updated. ${r.data}', );
        Navigator.pop(context);
      }
    });
  }
  // 이것도 잡아리..TODO 할 수 있지?
  void followingUser(
      {required UserModel tweetUser,
      required BuildContext context,
      required UserModel currentUser}) async {

    UserModel tweetUserLocal = tweetUser.copyWith();
    UserModel currentUserLocal = currentUser.copyWith();

    if (tweetUser.following == null) {
      // current user 가 following 할 수 있다.
      // 기억나잖아.. add 할 수가 없지.. UserModel 이 immutable 이니깐..
      //tweetUser.followers = [currentUser.uid!];
        tweetUser = tweetUser.copyWith(followers: [currentUser.uid!]);
      //currentUser.following?.add(tweetUser.uid!);
      currentUser = currentUser.copyWith(following: [tweetUser.uid!]);
    } else {
      if (tweetUser.following!.contains(currentUser.uid)) {
        // current user 가 following 할 수 없다.
        // unfollow 버턴 보여줘야 하고 누르면 지운다.
        // tweetUser.followers!.remove(currentUser.uid);
        List<String> followersTweetUserList = List.from(tweetUser.followers!);
        followersTweetUserList.removeWhere((element) => element == currentUser.uid);
        tweetUser = tweetUser.copyWith(followers: followersTweetUserList);

        //currentUser.following?.remove(tweetUser.uid);

        List<String> currentUserList = List.from(currentUser.following!);
        currentUserList.removeWhere((element) => element == tweetUser.uid);
        currentUser = currentUser.copyWith(followers: currentUserList);

      } else {
        // current user following 할 수 있다.
        // following 버턴 보여주고
        //tweetUser.followers?.add(currentUser.uid!);
        tweetUser = tweetUser.copyWith(followers: [...tweetUser.followers!, currentUser.uid!]);
        //currentUser.following?.add(tweetUser.uid!);
        currentUser = currentUser.copyWith(following: [...currentUser.following!, tweetUser.uid!]);

      }
    }
    tweetUser = tweetUser.copyWith(followers: tweetUser.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);

    final res = await _userAPI.followersUser(currentUser);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {

//        if (repliedToUserId.isNotEmpty) {
          _notificationController.createNotification(
              text: '${currentUser.name} followed you',
              postId: '', // 이부분 똑똑하네..
              notificationType: NotificationType.follow,
              context: context,
              uid: tweetUser.uid! // notification 전체에서 보여줄 uid
          ); // 아무것도 보여줄게 없고..

  //      }

      });
    });
  }
}
