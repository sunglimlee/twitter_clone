// I'm gonna put the common kind of providers for this project
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'as models;
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

final appWriteAccountProvider = Provider.autoDispose<Account>((ref) {
  final appWriteClientWatch = ref.watch(appWriteClientProvider);
  return Account(appWriteClientWatch);
});

final appWriteDatabasesProvider = Provider<Databases>((ref) {
  return Databases(ref.watch(appWriteClientProvider));
});

// state 프로바이더, 이거 잘못됐네.. 이렇게 하면 안되네.. StateNotifier 를 상속 받으면 사용할 수 있네..
final sessionStateProvider = StateProvider.autoDispose<models.Session?>((ref) {
  models.Session? session;
  return session;
});



// storage provider
final appWriteStorageProvider = Provider.autoDispose<Storage>((ref) {
  final appWriteClientWatch = ref.watch(appWriteClientProvider);
  return Storage(appWriteClientWatch);
});

// Realtime
final appWriteRealtimeProvider = Provider((ref) {
  final appWriteClientWatch = ref.watch(appWriteClientProvider);
  return Realtime(appWriteClientWatch);
});









