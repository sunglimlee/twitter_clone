import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../controller/tweet_controller.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(TweetModel tweetModel) =>
      MaterialPageRoute(
          builder: (context) => TwitterReplyScreen(tweetModel: tweetModel));

  final TweetModel _tweetModel;

  const TwitterReplyScreen({
    required TweetModel tweetModel,
    Key? key,
  })
      : _tweetModel = tweetModel,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [TweetCard(tweetModel: _tweetModel, canNavigate: false,),

          ref.watch(getRepliedToTweetProvider(_tweetModel)).when(
        data: (tweets) {
          print('tweets 의 값 (build)[twitter_reply_screen.dart] : ${tweets?.toList()}');
          if (tweets != null) {
            //final localTweets = [...tweets];
            return ref.watch(getLatestTweetProvider).when( // 얘네가 바꾸기를 원하네..
              data: (data) {
                if (data.events.contains(
                  'databases.*.collections.${AppWriteConstants
                      .tweetsCollection}.documents.*.create',
                )) {
                  // 여기 데이터 값이 나온거다. 메모리 어딘가에 저장되어 있고 이건 바뀌질 않았지..
                  tweets.insert(0, TweetModel.fromJson(data.payload));
                } else if (data.events.contains(
                  'databases.*.collections.${AppWriteConstants
                      .tweetsCollection}.documents.*.update',
                )) {
                  // get id of original tweet
                  // 여러가지 이벤트가 한꺼번에 올텐데 여기서는 그냥 events[0] 로 만드네..
                  final startingPoint =
                  data.events[0].lastIndexOf('documents.');
                  final endPoint = data.events[0].lastIndexOf('.update');
                  final tweetId = data.events[0]
                      .substring(startingPoint + 10, endPoint);

                  var tweet = tweets.where((element) => element.id == tweetId)
                      .first;

                  final tweetIndex = tweets.indexOf(tweet);
                  tweets.removeWhere((element) => element.id == tweetId);

                  tweet = TweetModel.fromJson(data.payload);
                  tweets.insert(tweetIndex, tweet);
                }
                // data.events.clear(); 이건 여기서 필요없지.. 왜냐면 밖에서도 되어야 하니깐..
                return Expanded(
                  child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweetModel: tweet,);
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  ErrorText(
                    errorMessage: error.toString(),
                  ),
              loading: () { // 맨처음에 stream 이 없으니 데이터 자체가 없는거지.. 그래서 여전히 List 를 리턴하는거고..
                return Expanded(
                  child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweetModel: tweet);
                    },
                  ),
                );
              },
            );
          } else { // null 이면 데이터를 보여줄 필요가 없지
            return Container();
          }
        },
        error: (error, stackTrace) => ErrorText(
          errorMessage: error.toString(),
        ),
        loading: () => const Loader(),
      ),
]

    ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
          child: TextField(
            onSubmitted: (text) {
              ref.read(tweetStateNotifierProvider.notifier).shareTweet(
                  images: [], text: text, context: context, repliedTo:_tweetModel.id, repliedToUserId: _tweetModel.uid);
            },
            decoration: const InputDecoration(hintText: 'Tweet your reply'),
          ),
        )

      )
      ,
    );
  }
}

/*
TextField(
        onSubmitted: (text) {
          ref.read(tweetStateNotifierProvider.notifier).shareTweet(
              images: [], text: text, context: context, repliedTo:_tweetModel.id);
        },
        decoration: const InputDecoration(hintText: 'Tweet your reply'),
      )
 */

/*


 */