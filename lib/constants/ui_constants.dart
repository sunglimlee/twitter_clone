import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/tweet/test/tweet_documents_list.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UIConstants {
  //static AppBar appBar = ReusableAppBar(); // 이게 아니네..
  // 뭔데 실컷 Stateless 애기해 놓고 static method 로 AppBar 를 넘기네..
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }
  // 나는 ui_constants 에 않넣고 여기에다가 넣었다. static function
  static List<Widget> childrenForIndexedStack() {
    final children = [
      TweetList(),
      TestTweetDocumentsList(),
      Text('Notificatin Screen'),
    ];
    return children;
  }

}
