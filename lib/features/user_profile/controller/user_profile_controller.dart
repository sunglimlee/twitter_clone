import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:appwrite/models.dart' as model;

final getDocumentByUserProvider = FutureProvider.autoDispose.family((ref, String uid) {
  final userProfileProviderWatch = ref.watch(userProfileProvider.notifier);
  return userProfileProviderWatch.getDocumentByUser(uid);
});

final userProfileProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(tweetAPI: ref.watch(tweetAPIProvider));
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;

  UserProfileController({required TweetAPI tweetAPI})
      : _tweetAPI = tweetAPI,
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
}
