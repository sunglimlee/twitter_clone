class AppWriteConstants {
  static const String databaseId =
      '64060667684fc4d269d9'; // 데이터베이스 id 가 내가 생각했던것과 다르구나..
  static const String projectId = '6406029c22f19e17f5be'; //
  // static const String endPoint = 'http://localhost:80/v1'; // 주소
  static const String endPoint = 'https://cloud.appwrite.io/v1'; // 주소
  static const String usersCollection =
      '640606de3ad71ab7097a'; // 서버의 databases/twitter test 데이터베이스/users 컬렉션 만들었다.
  static const String tweetsCollection =
      '6408cb6a94b7aa8e78c5'; // 서버의 databases/twitter test 데이터베이스/users 컬렉션 만들었다.
  static const String imagesBucket =
      '640b8375bea137cf267f'; // 서버의 databases/twitter test 데이터베이스/users 컬렉션 만들었다.

  // url 을 이용해서 이미지를 받아올 데테 그 url 을 id 를 받아와서 함수를 이용해서 url 을 만들어준다.
  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}

/*
class AppWriteConstants {
  static const String databaseId = '63f6464fb58db2e95e63'; // 데이터베이스 id 가 내가 생각했던것과 다르구나..
  static const String projectId = '63f6383e33ca0c4f53d0'; //
  // static const String endPoint = 'http://localhost:80/v1'; // 주소
  static const String endPoint = 'http://192.168.2.15:80/v1'; // 주소
  static const String usersCollection = '63ff771bdd46a0019dec'; // 서버의 databases/twitter test 데이터베이스/users 컬렉션 만들었다.
}
*/
