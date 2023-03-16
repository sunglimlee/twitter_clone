import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/model/tweet_model.dart';


class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("전체 고침");
    // 이게 되는 이유를 이제 알았다. 여기밖에 안쓰이고 여기에서 나가지 않았고 그래서 계속 상태가 유지가 되고 있다.
    // 그래서 다시 build 를 할 필요가 없다. 뭘? tweets 값을
    // 한번 만들어진 상태로 그대로 유지되고 있다.
    return ref.watch(getTweetsProvider).when(
      data: (tweets) { // 없는데...
        //final localTweets = [...tweets];
        return ref.watch(getLatestTweetProvider).when( // 얘네가 바꾸기를 원하네..
          data: (data) {
            if (data.events.contains(
              'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create',
            )) {
              // 여기 데이터 값이 나온거다. 메모리 어딘가에 저장되어 있고 이건 바뀌질 않았지..
              tweets.insert(0, TweetModel.fromJson(data.payload));
            } else if (data.events.contains(
              'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update',
            )) {
              // get id of original tweet
              // 여러가지 이벤트가 한꺼번에 올텐데 여기서는 그냥 events[0] 로 만드네..
              final startingPoint =
              data.events[0].lastIndexOf('documents.');
              final endPoint = data.events[0].lastIndexOf('.update');
              final tweetId = data.events[0]
                  .substring(startingPoint + 10, endPoint);

              var tweet = tweets
                  .where((element) => element.id == tweetId)
                  .first;

              final tweetIndex = tweets.indexOf(tweet);
              tweets.removeWhere((element) => element.id == tweetId);

              tweet = TweetModel.fromJson(data.payload);
              tweets.insert(tweetIndex, tweet);
            }
            data.events.clear();
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweetModel: tweet,);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
            errorMessage: error.toString(),
          ),
          loading: () { // 맨처음에 stream 이 없으니 데이터 자체가 없는거지.. 그래서 여전히 List 를 리턴하는거고..
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweetModel: tweet);
              },
            );
          },
        );
      },
      error: (error, stackTrace) => ErrorText(
        errorMessage: error.toString(),
      ),
      loading: () => const Loader(),
    );
  }
}
