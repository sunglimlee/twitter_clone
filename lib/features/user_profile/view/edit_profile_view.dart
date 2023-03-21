import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/model/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  final UserModel _userModel;
  final VoidCallback _callback;

  EditProfileView({
    Key? key,
    required UserModel userModel,
    required VoidCallback callback,
  })  : _userModel = userModel,
  _callback = callback,
        super(key: key);

  static route({required UserModel userModel, required VoidCallback callback}) => MaterialPageRoute(
        builder: (context) => EditProfileView(
          userModel: userModel,
          callback: callback,
        ),
      );

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerPicture;
  File? profilePicture;

  @override
  void initState() {
    super.initState();
    if (widget._userModel.name != null) {
      nameController = TextEditingController(text: widget._userModel.name!);
    }
    if (widget._userModel.bio != null) {
      bioController = TextEditingController(text: widget._userModel.bio!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerPicture = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profilePicture = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserDetailsProvider);
    final isLoading = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              final UserModel tempUserModel = currentUser.value!.copyWith(name: nameController.text, bio: bioController.text);
              final res = ref.read(userProfileProvider.notifier);
              res.updateUserModel(userModel: tempUserModel, context: context, bannerFile: bannerPicture, profileFile: profilePicture, callback : widget._callback);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: currentUser.when(data: (data) {
        return isLoading  || data == null
            ? const Loader()
            : Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      // SliverAppBar 전체 영역(150)에서 Position 과ㅏ Container 를 이용해 위치를 잡고 있다.
                      children: [
                        // 배경
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.maxFinite,
                            height: 145,
                            // SizedBox 를 200 으로 했는데 자식인 Container 를 150 으로 하니깐.. 밑의 CircleAvata 가 bottom 이니깐 반걸친것처럼 보인다.
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                              color: widget._userModel.bannerPic == null
                                  ? Pallete.blueColor
                                  : Colors.transparent,
                              image: bannerPicture != null
                                  ? DecorationImage(
                                      image: FileImage(bannerPicture!),
                                      fit: BoxFit.fitWidth,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(widget._userModel.bannerPic!),
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                            // ok. 여기서부터... 너무 힘들어서 좀 쉰다. TODO
                          ),
                        ),
                        Positioned(
                          bottom: 20, // 현재 SliverAppBar 의 최대 크기의 맨마지막으로 부터 붙는다.
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              selectProfileImage();
                            },
                            child: profilePicture != null
                                ? // 왜 이렇게 두개로 나누어야 되는걸까? 모르지만 아무튼 되네..ImageProvider 에러 더이상 안생긴다.
                                CircleAvatar(
                                    backgroundImage: FileImage(profilePicture!),
                                    radius: 40,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget._userModel.profilePic!),
                                    radius: 40,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(20.0).copyWith(top: 8, bottom: 8),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        contentPadding:
                            null, // 나는 밖에다 Padding 을 만들었다. 그게 더 예쁘다.
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(20.0).copyWith(top: 8, bottom: 8),
                    child: TextField(
                      controller: bioController,
                      decoration: const InputDecoration(
                        hintText: 'Biography',
                        contentPadding:
                            null, // 나는 밖에다 Padding 을 만들었다. 그게 더 예쁘다.
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              );
      }, error: (e, st) {
        return const ErrorPage();
      }, loading: () {
        return const LoadingPage();
      }),
    );
  }
}
