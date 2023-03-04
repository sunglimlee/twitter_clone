import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/view/create_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const HomeView());
  }

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final appBar = UIConstants.appBar();
  int _page = 1;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetView.materialPageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // 이렇게 build 함수 밖에 변수를 두고 사용하면 rebuild 를 줄여준다.
      bottomNavigationBar: CupertinoTabBar(
        onTap: onPageChange,
        currentIndex: _page,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
            AssetsConstants.searchIcon,
            color: Pallete.whiteColor,
          )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
            _page == 2
                ? AssetsConstants.notifFilledIcon
                : AssetsConstants.notifOutlinedIcon,
            color: Pallete.whiteColor,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {onCreateTweet();},
        child: const Icon(Icons.add,color: Pallete.whiteColor, size: 28,),
      ),
      body: Center(
        child: IndexedStack(
          index: _page,
          children: UIConstants.childrenForIndexedStack(),
        ),
      ),
    );
  }
}
