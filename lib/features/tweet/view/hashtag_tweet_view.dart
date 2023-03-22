import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';

// 새화면에서 Hashtag 를 받아와서 controller 를 부르는게 맞지. 그래야 loading 을 새화면에서 할 수 있으니깐..
// List<TweetModel> 받는걸로 하면 이전화면에서 멈춰있다가 새화면으로 바로가는거거든 그건 별로 좋은 방법이 아니다.
// 라반이 맞는거다. 내가 틀렸고.. 다음에는 안틀려야지..
class HashtagTweetView extends ConsumerWidget {
  final String _hashtag;

  const HashtagTweetView({
    required String hashtag,
    Key? key,
  })  : _hashtag = hashtag,
        super(key: key);

  static route({required String hashtag}) => MaterialPageRoute(
        builder: (context) => HashtagTweetView(hashtag: hashtag),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet List by $_hashtag'),
      ),
      body: ref.watch(getTweeModelByHashTagProvider(_hashtag)).when(
          data: (tweetModels) {
        return ListView.builder(
            itemCount: tweetModels.length,
            itemBuilder: (context, index) {
              return TweetCard(tweetModel: tweetModels[index]);
            });
      }, error: (e, st) {
        return ErrorPage(
          errorMessage: e.toString(),
        );
      }, loading: () {
        return const Loader();
      }),
    );
  }
}
