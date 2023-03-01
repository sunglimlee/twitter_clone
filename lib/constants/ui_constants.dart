import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
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
}
