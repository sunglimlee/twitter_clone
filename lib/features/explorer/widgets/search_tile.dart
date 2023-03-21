import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/model/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SearchTile extends ConsumerWidget {
  final UserModel _userModel;

  const SearchTile({super.key, required UserModel userModel})
      : _userModel = userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: (){
        print('search_tile 에서 실행되었습니다.');
        Navigator.push(context, UserProfileView.route(_userModel),);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_userModel.profilePic ??
            'https://png.pngtree.com/png-clipart/20181003/ourmid/pngtree-twitter-social-media-icon-design-template-vector-png-image_3654790.png'),
      ),
      title: Text(
        '${_userModel.name}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${_userModel.name}',
            style: const TextStyle(
              fontSize: 16,
              color: Pallete.greyColor,
            ),
          ),
          Text(
            '${_userModel.bio}',
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
