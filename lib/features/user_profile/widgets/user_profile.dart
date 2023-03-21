import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/model/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel _userModel;

  const UserProfile({Key? key, required UserModel userModel,})
      : _userModel = userModel,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('userProfile 값을 찍어주세요. ${_userModel.toString()}');
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    // SliverAppBar 전체 영역(150)에서 Position 과ㅏ Container 를 이용해 위치를 잡고 있다.
                    children: [
                      Positioned.fill(
                        child: _userModel.bannerPic == null
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(_userModel.bannerPic!, fit: BoxFit.fitWidth,),
                      ),
                      Positioned(
                        bottom: 0, // 현재 SliverAppBar 의 최대 크기의 맨마지막으로 부터 붙는다.
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_userModel.profilePic!),
                          radius: 45,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.bottomRight,
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Pallete.whiteColor),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              onPressed: () {
                                if (currentUser.uid == _userModel.uid) {
                                  Navigator.push(
                                    context, EditProfileView.route(userModel: _userModel,));
                                }
                              },
                              child: Text(
                                currentUser.uid == _userModel.uid
                                    ? 'Edit Profile'
                                    : 'Follow',
                                style: const TextStyle(
                                  color: Pallete.whiteColor,
                                ),
                              ))),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          _userModel.name ?? '',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '@${_userModel.name ?? ''}',
                          style: const TextStyle(
                              fontSize: 17, color: Pallete.greyColor),
                        ),
                        Text(
                          _userModel.bio ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowCount(
                              count: _userModel.following?.length ?? 0,
                              text: 'Following',
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FollowCount(
                              count: _userModel.followers?.length ?? 0,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Pallete.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getDocumentByUserProvider(_userModel.uid!)).when(
                data: (data) {
              // Make it on realtime TODO
              if (data != null) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tweet = data[index];
                      return TweetCard(tweetModel: tweet);
                    });
              } else {
                return const SizedBox();
              }
            }, error: (e, st) {
              return ErrorPage(errorMessage: e.toString());
            }, loading: () {
              return const LoadingPage();
            }));
  }
}










/* 원본

class UserProfile extends ConsumerWidget {
  final UserModel _userModel;
  final VoidCallback _callBack;

  const UserProfile({Key? key, required UserModel userModel, required VoidCallback callback})
      : _userModel = userModel,
        _callBack = callback,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('userProfile 값을 찍어주세요. ${_userModel.toString()}');
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    // SliverAppBar 전체 영역(150)에서 Position 과ㅏ Container 를 이용해 위치를 잡고 있다.
                    children: [
                      Positioned.fill(
                        child: _userModel.bannerPic == null
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(_userModel.bannerPic!, fit: BoxFit.fitWidth,),
                      ),
                      Positioned(
                        bottom: 0, // 현재 SliverAppBar 의 최대 크기의 맨마지막으로 부터 붙는다.
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_userModel.profilePic!),
                          radius: 45,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.bottomRight,
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Pallete.whiteColor),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              onPressed: () {
                                if (currentUser.uid == _userModel.uid) {
                                  Navigator.push(
                                    context, EditProfileView.route(userModel: _userModel, callback : _callBack));
                                }
                              },
                              child: Text(
                                currentUser.uid == _userModel.uid
                                    ? 'Edit Profile'
                                    : 'Follow',
                                style: const TextStyle(
                                  color: Pallete.whiteColor,
                                ),
                              ))),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          _userModel.name ?? '',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '@${_userModel.name ?? ''}',
                          style: const TextStyle(
                              fontSize: 17, color: Pallete.greyColor),
                        ),
                        Text(
                          _userModel.bio ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowCount(
                              count: _userModel.following?.length ?? 0,
                              text: 'Following',
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FollowCount(
                              count: _userModel.followers?.length ?? 0,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Pallete.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getDocumentByUserProvider(_userModel.uid!)).when(
                data: (data) {
              // Make it on realtime TODO
              if (data != null) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tweet = data[index];
                      return TweetCard(tweetModel: tweet);
                    });
              } else {
                return const SizedBox();
              }
            }, error: (e, st) {
              return ErrorPage(errorMessage: e.toString());
            }, loading: () {
              return const LoadingPage();
            }));
  }
}



 */