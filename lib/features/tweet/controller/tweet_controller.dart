import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/model/user_model.dart';

// 외부에서 storageAPI 가 들어갈 때는 storage 의 provider 를 이용해서 객체를 만들어서 넣어주겠지..
final tweetStateNotifierProvider =
    StateNotifierProvider.autoDispose<TweetControllerNotifier, bool>((ref) =>
        TweetControllerNotifier(
            ref: ref,
            tweetAPI: ref.watch(tweetAPIProvider),
            storageAPI: ref.watch(storageAPIProvider)));

final getTweetsProvider = FutureProvider.autoDispose((ref) {
  final tweetStateNotifierWatch = ref.watch(
      tweetStateNotifierProvider.notifier); // 이말 정확히 이해되지? 프로바이더에서 watch 를 받았다.
  return tweetStateNotifierWatch.getTweetDocuments();
});

final getLatestTweetProvider =
    StreamProvider.autoDispose<RealtimeMessage>((ref) {
  // 여기서는 특이하게도 api 에서 바로 받네.. 언제는 바로 받는거 하지 말라고 하더만...
  // 하긴 controller 에서 할 게 없다면 바로 받아도 되지.. 받는 데이터가 Stream<RealtimeMessage> 이니깐..
  // 잘봐라.. TweetControllerNotifier 에는 getLatestTweet() 함수가 존재하지 않는다. 할게 없기 때문이란다.  말되긴 하네..
  final tweetApiWatch = ref.watch(tweetAPIProvider);
  return tweetApiWatch.getLatestTweet();
});

class TweetControllerNotifier extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;

  Ref _ref; // 여기서 만들 때 ref 를 어떻게 넣는지 보자.. 아마도 provider 에서 값을 넣을 것 같지..
  TweetControllerNotifier(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  /// 트윗 도큐먼트를 받는다.
  Future<List<TweetModel>> getTweetDocuments() async {
    final tweetList = await _tweetAPI.getTweetDocuments();
    return tweetList.map((tweet) {
      return TweetModel.fromJson(tweet
          .data); // 제발 꼭 기억하자..Document 객체이지 Map<dynamic, dynamci> 객체는 아니잖아...
    }).toList();
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Text');
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  // 여기서 await 가 두번 들어가고 있다.
  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    //_ref.invalidate(tweetStateNotifierProvider);
    state = true;
    final hashTags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);
    // 이부분 너무나도 중요하고 아름다운 부분이다. 왜냐면 너도 알다시피 AsyncData 값을 받으면 다음으로 계속 넘어가고 다음번에 데이터가 들어왔을 때 처리하는데
    // 이경우에는 uid 값이 존재하지 않는 상태에서 TweetModel 의 객체가 만들어지는거지.. 값이 완전히 받아지고 나서 들어오도록 해야하는데..
    // 그래서 아래처럼 .future 를 사용하면 await 로 기다리게 할 수 있잖아..
    final uid = await _ref.read(currentUserIdProvider.future);
    print(uid);
    TweetModel tweetModel = TweetModel(
        text: text,
        uid: uid.toString(),
        likes: const [],
        commentIds: const [],
        tweetType: TweetType.text,
        tweetAt: DateTime.now(),
        link: link,
        hashTags: hashTags,
        imageLinks: const [],
        reshareCount: 0);
    // tweet 저장하는 부분
    final res = await _tweetAPI.shareTweet(tweetModel);
    // 여기서부터 Either 부분 처리해야 한다.
    // 중요한건 fold 도 리턴값이 있다. 그래서 reply 에 관련된 부분이 들어갈 텐데 지금은 그냥 null 을 리턴해도 된다.
    // 재밌는 사실은 fpdart 에서 사용되는 fold 함수가 정작 양쪽에서 리턴되는 갑은 C 로 같다는 사실
    state = false;
    print('res 값 ${res}');
    res.fold((l) => showSnackBar(context, l.message), (r) {
      //_ref.refresh(tweetStateNotifierProvider);
    });
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    // 여기 image 는 조금 다르게 저장이 될 거다. 절차를 잘보고 결정하도록 하자.
    // Storage 에 저장이 될거고..
    state = true;
    final hashTags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);
    // 이부분 너무나도 중요하고 아름다운 부분이다. 왜냐면 너도 알다시피 AsyncData 값을 받으면 다음으로 계속 넘어가고 다음번에 데이터가 들어왔을 때 처리하는데
    // 이경우에는 uid 값이 존재하지 않는 상태에서 TweetModel 의 객체가 만들어지는거지.. 값이 완전히 받아지고 나서 들어오도록 해야하는데..
    // 그래서 아래처럼 .future 를 사용하면 await 로 기다리게 할 수 있잖아..
    final uid = await _ref.read(currentUserIdProvider.future);
    print(uid);
    final imageLinks = await _storageAPI.upLoadImage(images);
    TweetModel tweetModel = TweetModel(
        text: text,
        uid: uid.toString(),
        likes: const [],
        commentIds: const [],
        tweetType: TweetType.image,
        // 모이지? 이미지를 저장하는거다.
        tweetAt: DateTime.now(),
        link: link,
        hashTags: hashTags,
        imageLinks: imageLinks,
        reshareCount: 0);
    // tweet 저장하는 부분
    final res = await _tweetAPI.shareTweet(tweetModel);
    // 여기서부터 Either 부분 처리해야 한다.
    // 중요한건 fold 도 리턴값이 있다. 그래서 reply 에 관련된 부분이 들어갈 텐데 지금은 그냥 null 을 리턴해도 된다.
    // 재밌는 사실은 fpdart 에서 사용되는 fold 함수가 정작 양쪽에서 리턴되는 갑은 C 로 같다는 사실
    state = false;
    print('res 값 ${res}');
    res.fold((l) => showSnackBar(context, l.message), (r) {
      return null;
    });
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') ||
          word.startsWith('http://') ||
          word.startsWith('www')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    List<String> hashTags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashTags.add(word);
      }
    }
    return hashTags;
  }

  void likeTweet(TweetModel tweetModel, UserModel userModel) async {
    print(
        'userModel.uid! ${userModel.uid ?? 'userModel.uid 의 값이 존재하지 않습니다.'}: (likeTweet)[tweet_controller.dart]');
    print('tweetModel (likeTweet)[tweet_controller] ${tweetModel.toString()}');
    List<String> likes = [];
    likes = tweetModel.likes ?? [];
    print('likes 의 형 (likeTweet)[tweet_controller] : ${likes.toString()}');
    if (tweetModel.likes != null) {
      print(
          'tweetModel 전체 (likeTweet)[tweet_controller] : ${tweetModel.likes.toString()}');
      if (tweetModel.likes!.contains(userModel.uid)) {
        //likes.remove(userModel.uid);
        likes = List.from(likes)..remove(userModel.uid!);
        print('likes after remove : ${likes.toString()}');
      } else {
        //likes = .add(userModel.uid!);
        likes = List.from(likes)..add(userModel.uid!);
        print('likes after add : ${likes.toString()}');
        // likes 가 immutable 이라고 add 가 안된다.
      }
    }
    // 이제 tweetModel 을 업데이트 해야하는데 꼭 기억할게 이건 immutable 라는 사실이다.
    // 그래서 copyWith 를 반드시 사용하도록 하자.
    tweetModel = tweetModel.copyWith(likes: likes);
    print(
        'tweetModel 전체 (likeTweet)[tweet_controller] : ${tweetModel.likes.toString()}');
    final res = await _tweetAPI.likeTweet(tweetModel);
    // 여기부터 fold 함수 사용할 것임..
    res.fold((l) {
      return null; // 아무것도 보여줄게 없다.
    }, (r) {
      return null; // 아무것도 보여줄게 없고..
    });

    // likes.add(userModel.uid!); // 여기는 null 이 되면 안되지..
    likes = List.from(likes)..add(userModel.uid!);
  }
}
