import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.md';
import 'package:twitter_clone/theme/pallete.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const CreateTweetView());
  }

  const CreateTweetView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void onPickImages() async {
    images = await pickImages(); // 함수를 이용해서 이 클래스 멤버변수에 값을 옮겼다. 이제 이 멤버들이 모두 이 멤버변수를 사용할 수 있다.
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
            color: Pallete.whiteColor,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () {},
            buttonLabel: 'Tweet',
            backgroundColor: Pallete.blueColor,
          ),
        ],
      ),
      // 이런 디테일 한 것도 넣어주자. 지금 currentUser 에 대한 값을 받는거니깐 당연히 currentUser null check 로 LoadingPage 기능도 넣어주어야지..
      body: currentUser == null
          ? const Loader()
          : SafeArea(
          child: SingleChildScrollView(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(currentUser.profilePic ??
                      'https://i.pinimg.com/originals/69/18/db/6918db95c0f5675ee30e5f6f3445daa6.png'),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: tweetTextController,
                    //expands: true,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                      hintText: "What's happening?",
                      hintStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Pallete.greyColor,
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                )
              ],
            ),
          )),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Pallete.greyColor, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0).copyWith(left: 20, right: 20),
              child: GestureDetector(child: SvgPicture.asset(AssetsConstants.galleryIcon)
                , onTap:() {pickImages(); } ,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0).copyWith(left: 20, right: 20),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0).copyWith(left: 20, right: 20),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
