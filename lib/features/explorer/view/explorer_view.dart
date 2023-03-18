import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/explorer/controller/explorer_controller.dart';
import 'package:twitter_clone/features/explorer/widgets/search_tile.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExplorerView extends ConsumerStatefulWidget {
  const ExplorerView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExplorerViewState();
}

class _ExplorerViewState extends ConsumerState<ExplorerView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              hintText: 'Search Twitter',
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? () {
              final searchUserByNameProviderWatch =
                  ref.watch(searchUserByNameProvider(searchController.text));
              // 항상 사소한 실수인데 when 함수에 대한 return 을 또 안넣어서 이렇게 1시간을 헤매게 되었네...
              return searchUserByNameProviderWatch.when(data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      //return Text('${user.name}');
                      return SearchTile(userModel: user);
                    },
                  );
              }, error: (e, st) {
                return ErrorPage(
                  errorMessage: e.toString(),
                );
              }, loading: () {
                return const Loader();
              });
            }()
          : const SizedBox(child: Text('not found'),),
    );
  }
}
