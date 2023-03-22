import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/features/tweet/view/hashtag_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String _text;

  const HashtagText({Key? key, required String text})
      : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    _text.split(' ').forEach((element) { // 여기서도 리스트를 이용해서 hashtag 를 나누고 그 해시태그를 이용해서 작업하는걸 보여주고 있다.
      if (element.startsWith('#')) {
        textSpans.add(
          TextSpan(
              text: '$element ',
              recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.push(context, HashtagTweetView.route(hashtag: element),);
          },
              style: const TextStyle(
                  color: Pallete.blueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpans.add(
        TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            )),
        );
      } else { // 이게 왜 있는거지???
        textSpans.add(
        TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            )),
        );}
    });
    // 이런걸 어떻게 아냐????
    return RichText(text: TextSpan(children: textSpans));
  }
}
