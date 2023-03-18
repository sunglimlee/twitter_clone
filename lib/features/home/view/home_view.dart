import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/features/tweet/view/create_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static route() => MaterialPageRoute(
    builder: (context) => const HomeView(),
  );
  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final appBar = UIConstants.appBar();
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateTweetScreen()));
  }

  @override
  Widget build(BuildContext context) {
    print('여긴 홈');
    //print('Riverpod Session 값 (build)[home_view.dart] ${ref.watch(sessionStateProvider)!.userId}');
    // final session = ref.watch(sessionStateProvider);
    // print('SessionSP 값: ${session?.userId??"세션값이 없군요."}');
    return Scaffold(
      appBar: _page == 0 ? appBar : null, // 이렇게 build 함수 밖에 변수를 두고 사용하면 rebuild 를 줄여준다.
      body: Center(
        child: IndexedStack(
          index: _page,
          children: UIConstants.childrenForIndexedStack(),
        ),
      ),
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
        onPressed: () {
          onCreateTweet();
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
    );
  }
}
