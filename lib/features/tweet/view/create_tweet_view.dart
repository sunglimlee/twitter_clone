import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );

  const CreateTweetScreen({super.key});

  @override
  ConsumerState<CreateTweetScreen> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  List<File> images = []; // 이 클래스 전체에서 사용하도록 전역 변수를 만들어준다. 좋은 아이디어다.

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void shareTweet() {
    ref.read(tweetStateNotifierProvider.notifier).shareTweet(
        images: images, text: tweetTextController.text, context: context);
    // 여기는 말 그래도 화면상이니깐 여기서 Navigation 하는게 맞지.
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 이 한줄을 위해서 4일을 헤맸다.
    // 그래 이 한줄을 위해서 4일을 헤맸는데 니가 실수한게 여전히 이유를 몰랐다는거지.. 왜냐면 계속 AsyncData 를 가지고 비동기로 처리하니깐 currentUseId 값을 계속 null 이라는거지..
    // 이게 싫다면 FutureBuilder 를 사용하면 된다. 왜냐면 build 함수가 Widget 을 리턴하니깐 Future 가 완료되면 Widget 을 넘기도록 하면 되잖아.. 그게 말이되지..
    final currentUserId = ref.watch(currentUserAccountProvider).value?.$id ??
        ref.watch(sessionStateProvider)?.userId;
    print('A: currentUserId (build) [create_tweet_view.dart] $currentUserId'); // currentUserId 존재하는데???
    final userDetailsWatch = ref.watch(userDetailsProvider(currentUserId!));
    print('B: userDetailsWatch ${userDetailsWatch.value}');
    final userDetails =
        userDetailsWatch.when(data: (data) {
      return data;
    }, error: (e, stackStrace) {
      const ErrorPage(
        errorMessage: 'userDetail 에러가 발생했습니다.',
        // 나중에 여기에 메세지를 띄워주고 계속 가도록 하는 것도 방법이다.
      );
    }, loading: () {
      const LoadingPage();
    });
    print('userDetails : ${userDetails ?? "값이 존재하지 않습니다."}');

    final isLoading =
        ref.watch(tweetStateNotifierProvider); // 이렇게만 하면 state 가 리턴된다는 거 알고 있지?

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          () {
            Widget tweetButton;
            tweetButton = RoundedSmallButton(
              onTap: shareTweet,
              buttonLabel: 'Tweet',
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            );
            return tweetButton;
          }(),
        ],
      ),
      body: userDetails == null || isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userDetails.profilePic!),
                          radius: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty) // 전역변수
                      // 그럼 이런식으로 저장이 된다는 건가????
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
