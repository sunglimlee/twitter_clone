import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
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

  UserProfileController(
      {required TweetAPI tweetAPI,
      required StorageAPI storageAPI,
      required UserAPI userAPI})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
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
        showSnackBar(context, 'Profile successfully updated. ${r.data}', );
        Navigator.pop(context);
      }
    });

  }

}
