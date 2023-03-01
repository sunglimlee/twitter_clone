

// 이말이 무슨 뜻인가? 결국 내가 원하는 데이터 형으로 만들어서 Either 에 넣어주겠다는 거지..
class Failure {
  final String message;
  final StackTrace stackTrace;
  const Failure({required this.message, required this.stackTrace});
}
