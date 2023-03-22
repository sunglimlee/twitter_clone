import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_cotroller.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/theme/pallete.dart';


class SiderDrawer extends ConsumerWidget {
  final Color _backgroundColor;

  const SiderDrawer({
    Key? key,
    Color backgroundColor = Pallete.backgroundColor,
  })
      : _backgroundColor = backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModel = ref.watch(currentUserDetailsProvider);
    return currentUserModel.when(
        data: (data) {
          if (data != null) {
            return SafeArea(child: Drawer(
              backgroundColor: _backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, size: 30,),
                      title: const Text('My Profile', style: TextStyle(
                        fontSize: 22,

                      ),),
                      onTap: () {
                        if (currentUserModel != null) {
                          Navigator.push(context, UserProfileView.route(data));
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.payment, size: 30,),
                      title: const Text('Twitter Blue', style: TextStyle(
                        fontSize: 22,

                      ),),
                      onTap: () {
                        final res = ref.watch(userProfileProvider.notifier)
                            .updateUserModel(userModel: currentUserModel.value!
                            .copyWith(isTwitterBlue: true),
                            context: context,
                            bannerFile: null,
                            profileFile: null);

                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, size: 30,),
                      title: const Text('Logout', style: TextStyle(
                        fontSize: 22,

                      ),),
                      onTap: () {
                        ref.watch(authControllerProvider.notifier).logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ));
          } else {
            return const Loader();
          }
        },
        error: (e, st) {
          return const ErrorPage(errorMessage: 'Loading 하지 못했습니다.',);
        }, loading: () => const Loader());
  }
}
