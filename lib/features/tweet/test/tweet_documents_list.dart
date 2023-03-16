import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/assets_constants.dart';
import '../widgets/tweet_card.dart';

// 이 부분은 화면 디자인 부분이다. 아주 중요한 부분이다.
class TestTweetDocumentsList extends ConsumerWidget {
  //final TweetModel _tweetModel;

  const TestTweetDocumentsList({
    //required TweetModel tweetModel,
    Key? key,
  })  : //_tweetModel = tweetModel,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(getTweetsProvider);
    return res.when(data: (tweets) {
      return ListView.builder(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweets[index];
          return Text('${tweet.likes != null ? tweet.likes!.length : 0}.');
        },
      );
    }
    , error: (e, st) {
        return ErrorPage(errorMessage: e.toString(),);
        }, loading: () {
          return const LoadingPage();
        });
  }
}
