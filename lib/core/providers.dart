// I'm gonna put the common kind of providers for this project
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';


// 이제는 이해가 되고 좀 쉬워지네..
// 그냥 메뉴얼을 보면 이렇게 해야 연결된다고 애기할거다.
// 여기 보는것처럼 Client 가 여러번 사용되니깐 외부에서 불러들이고 Riverpod 에 올린거고.. ⭐⭐⭐⭐⭐⭐ dependency 가 필요한지 확인하자..️
final appWriteClientProvider = Provider<Client>((ref) {
  Client client = Client(endPoint: AppWriteConstants.endPoint);
  client.setProject(AppWriteConstants.projectId);
  client.setSelfSigned(status: true); // 개발하는 시점에만 true 라고 해야 한단다.
  return client;
}); // selfSigned 가 뭐지?

final appWriteAccountProvider = Provider<Account>((ref) {
  final appWriteClientWatch = ref.watch(appWriteClientProvider);
  return Account(appWriteClientWatch);
});

final appWriteDatabasesProvider = Provider<Databases>((ref) {
  return Databases(ref.watch(appWriteClientProvider));
});