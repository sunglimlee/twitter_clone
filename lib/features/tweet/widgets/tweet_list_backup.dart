/*
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
    final tweets =
    ref.watch(tweetStateNotifierProvider.notifier).getTweetDocuments();
    return FutureBuilder(
        initialData: null,
        future: tweets,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingPage();
            default:
              if (snapshot.hasError) {
                return const ErrorPage();
              } else {
                return snapshot.data == null
                    ? const Center(child: Text('No tweet to show'))
                    : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final tweet = snapshot.data![index];
                      return TweetCard(tweetModel: tweet);
                    });
              }
          }
        });
  }
}
*/
