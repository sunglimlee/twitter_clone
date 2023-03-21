import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/model/user_model.dart';


final explorerControllerProvider = StateNotifierProvider.autoDispose<ExplorerControllerStateNotifier, bool>((ref) {
  final userAPIProviderWatch = ref.watch(userAPIProvider);
  return ExplorerControllerStateNotifier(userAPI: userAPIProviderWatch);
});

final searchUserByNameProvider = FutureProvider.autoDispose.family((ref, String name)  {
  final explorerControllerProviderWatch = ref.watch(explorerControllerProvider.notifier);
  return explorerControllerProviderWatch.searchUserByName(name);
});


class ExplorerControllerStateNotifier extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExplorerControllerStateNotifier({required UserAPI userAPI}) : _userAPI = userAPI, super(false);

  Future<List<UserModel>> searchUserByName(String name) async { // 나는 이거는 uid 로 찾아야 된다고 본다.
    final documents = await _userAPI.searchUserByName(name);
    return documents.map((e) => UserModel.fromJson(e.data)).toList();
  }
}
