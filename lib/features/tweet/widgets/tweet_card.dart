import 'dart:ffi';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/twitter_reply_screen.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/assets_constants.dart';

// 이 부분은 화면 디자인 부분이다. 아주 중요한 부분이다.
class TweetCard extends ConsumerWidget {
  final bool _canNavigate;
  final TweetModel _tweetModel; // 외부의 state

  const TweetCard({
    required TweetModel tweetModel,
    bool canNavigate = true,
    Key? key,
  })  : _tweetModel = tweetModel,
        _canNavigate = canNavigate,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider).value;
    return currentUserId == null
        ? Container()
        : ref.watch(userDetailsProvider(currentUserId)).when(
            // 이것도 외부의 state
            data: (userModel) {
              return GestureDetector(
                onTap: () {
                  if (_canNavigate) {
                    Navigator.push(
                      context, TwitterReplyScreen.route(_tweetModel));
                  }
                },
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: (){
                              print('tweet card 에서 실행되었습니다.');
                              Navigator.push(context, UserProfileView.route(userModel));
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userModel.profilePic!),
                              radius: 35,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_tweetModel.retweetedBy != null)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsConstants.retweetIcon,
                                      color: Pallete.greyColor,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      '${_tweetModel.retweetedBy} retweeted  · ${timeago.format(_tweetModel.tweetAt, locale: 'en_short')} ',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Pallete.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              Row(children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    userModel.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                Text(
                                  '@${userModel.name!} · ${timeago.format(_tweetModel.tweetAt, locale: 'en_short')} ׄ',
                                  style: const TextStyle(
                                      fontSize: 15, color: Pallete.greyColor),
                                ),
                              ]),
                              // repliedTo
                              if (_tweetModel.repliedTo != null)
                                RichText(
                                  text: TextSpan(
                                      text: 'Replying to ',
                                      style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: (_tweetModel.repliedTo != null) ?
                                                  '@ ${ref.watch(getUserModelByTweetModelProvider(_tweetModel.repliedTo!)).value}' : '',
                                          style: const TextStyle(
                                            color: Pallete.blueColor,
                                            fontSize: 16,
                                          ),
                                        )
                                      ]),
                                ),
                              HashtagText(text: _tweetModel.text),
                              // image
                              if (_tweetModel.tweetType == TweetType.image)
                                CarouselImage(
                                    imageLinks: _tweetModel.imageLinks!),
                              // Web browser Showing
                              if (_tweetModel.link?.isNotEmpty ?? false) ...[
                                const SizedBox(height: 4),
                                AnyLinkPreview(
                                  link: 'https://${_tweetModel.link}',
                                ),
                              ],
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TweetIconButton(
                                      pathName: AssetsConstants.viewsIcon,
                                      text: ((_tweetModel.commentIds?.length ??
                                                      0)
                                                  .toInt() +
                                              (_tweetModel.reshareCount ?? 0) +
                                              (_tweetModel.likes?.length ?? 0)
                                                  .toInt())
                                          .toString(),
                                      onTap: null,
                                    ),
                                    TweetIconButton(
                                      pathName: AssetsConstants.commentIcon,
                                      text:
                                          ((_tweetModel.commentIds?.length ?? 0)
                                                  .toInt())
                                              .toString(),
                                      onTap: null,
                                    ),
                                    TweetIconButton(
                                      pathName: AssetsConstants.retweetIcon,
                                      text: ((_tweetModel.reshareCount ?? 0)
                                              .toInt())
                                          .toString(),
                                      onTap: () {
                                        ref
                                            .read(tweetStateNotifierProvider
                                                .notifier)
                                            .reshareTweet(
                                                _tweetModel,
                                                ref
                                                    .read(userDetailsProvider(
                                                        currentUserId))
                                                    .value!,
                                                context);
                                        //print('돌아온 tweetModel 값은 ${res3}');
                                      },
                                    ),
                                    LikeButton(
                                      size: 25,
                                      onTap: (isLiked) async {
                                        // 서버 저장하는 시간동안 애니메이션이 활성화 되는 구조였어... ㅋ
                                        print(
                                            'isLiked 값 : ${isLiked.toString()}');
                                        print(
                                            '_tweetModel 의 before .likeTweet (build)[tweet_cart.dart] ${_tweetModel.toString()}');
                                        ref
                                            .read(tweetStateNotifierProvider
                                                .notifier)
                                            .likeTweet(
                                                _tweetModel,
                                                ref
                                                    .watch(userDetailsProvider(
                                                        currentUserId))
                                                    .value!);
                                        print(
                                            'LikeButton 의 return 바로전 isLiked 값 : ${isLiked}');
                                        return !isLiked; // 이거 없어도 되지만 그냥 너무 빠르게 지나가지..
                                      },
                                      isLiked: () {
                                        //print('_tweetModel.likes 의 값 ${_tweetModel.toString()}');
                                        // 결국 state 의 상태로 결정되는거고..
                                        bool res = _tweetModel.likes == null
                                            ? false
                                            : _tweetModel.likes!
                                                    .contains(currentUserId)
                                                ? true
                                                : false;
                                        //print('res 의 값 : ${res}');
                                        return res;
                                      }(),
                                      likeBuilder: (isLiked) {
                                        //print('_tweetModel 의 likebuild 안에서 (build)[tweet_cart.dart] ${_tweetModel.toString()}');

                                        //print('likebuilder 의 isLiked 값 : ${isLiked}');
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                color: Pallete.redColor,
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .likeOutlinedIcon,
                                                color: Pallete.whiteColor,
                                              );
                                      },
                                      likeCount: _tweetModel.likes?.length ?? 0,
                                      // 누가 좋아했는지 uid 를 넣은거네..
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redColor
                                                  : Pallete.greyColor,
                                              fontSize: 17,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.share_outlined,
                                          size: 25,
                                          color: Pallete.greyColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Pallete.greyColor,
                    ),
                    // replied to
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorPage(
                  errorMessage: error.toString(),
                ),
            loading: () {
              return Container();
              //return const CircularProgressIndicator(color: Colors.blueAccent,);
            });
  }
}
