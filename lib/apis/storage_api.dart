import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/providers.dart';

// 나는 이번건은 provider 를 사용하지 않기로 한다.
// 근데 이 StrorageAPI 는 하나의 객체로 계속 사용될 거잖아. 그래서 새로 생성해서 작업하는것 보다 그냥 사용되는게 더 낫지 않나?

final storageAPIProvider = Provider.autoDispose((ref) {
  return StorageAPI(
      storage: ref
          .watch(appWriteStorageProvider)); // 이렇게 해놓으니깐 여기 객체의 함수에 한정이 되어버리네..
});

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  // 잘 생각해봐라. storage 를 외부에서 받았으니깐 이제부터 이 값을 이용해서 Future 를 사용할 거고...
  // 그 저장하는 값은 경로가 될거다. (경로를 공부하도록 하자.)
  // 아주 어려운줄 알았는데 로컬에 있는 데이터의 경로를 받았고 그 경로를 서버에 올렸고 다시 받은 건 $id 였다. 그 id 의 List<String> 을 리턴해주었다는 거지..
  Future<List<String>> upLoadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
          bucketId: AppWriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile(path: file.path));
      imageLinks.add(
        AppWriteConstants.imageUrl(uploadedImage.$id),
      ); // 여기도 결국 $id 였어..
    }
    return imageLinks;
  }
}
