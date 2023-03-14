import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';

import '../../../constants/appwrite_constants.dart';

class TweetList extends ConsumerWidget {
  const TweetList({
    Key? key,
  }) : super(key: key);

  // 이부분 아주 중요하다. 왜냐하면 여기서 Async 값을 받는걸로 되어 있잖아.. 현재 여기 있는 곳이 build 함수 안이므로 Widget 를 리턴해야하는데 그렇게 할 수 가 없잖아...
  // 이부분을 잘 보면 이제 해석을 할 수 있을 것 같다.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(data: (List<TweetModel> tweets) {
      return ref.watch(getLatestTweetProvider).when(data: (data) {
        // 그래서 데이터가 추가 되었는지 업데이트 되었는지 확인한다.
        if (data.events.contains(
            'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create')) {
          // tweets 에 insert 나 add 를 할 수 있는데 insert 를 해야지 맨처음으로 올라가겠지.. add 는 맨마지막에 추가를 하는거니깐..
          // 근데 이제 RealtimeMessage -> TweetModel 로 바꾸어야 하는데.. data.payload 가 실제 데이터를 담고있는 json 파일이구나.
          tweets.insert(0, TweetModel.fromJson(data.payload));
        }
        return tweets.isEmpty
            ? const Center(child: Text('No tweet to show'))
            : ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return TweetCard(tweetModel: tweet);
                });
      }, error: (e, st) {
        return ErrorPage(
          errorMessage: e.toString(),
        );
      }, loading: () {
        // 근데 이게 말이 안되는게 계속 실시간으로 검사하는데 그럼 계속 loading 을 하는거잖아...그러니깐.. 이부분을 data 를 보여주는 부부능로 대치하는게 맞지..
        //return const Loader();
        return tweets.isEmpty
            ? const Center(child: Text('No tweet to show'))
            : ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return TweetCard(tweetModel: tweet);
                });
      });
    }, error: (e, stackTrace) {
      print('에러 (build)[tweet_list] : ${e.toString()}');
      return ErrorPage(
        errorMessage: e.toString(),
      );
    }, loading: () {
      return const Loader();
    });
  }
}
