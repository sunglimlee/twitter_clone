import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';


// 모든 type definition 에 관련된 내용이 들어간다.
// 여기서 잘 봐야 할게 Success 는 여러가지 다른 데이터 형태를 받아올 수 있으므로 Generic type 형태로 만든다. 그게
typedef FutureEither<T> = Future<Either<Failure, T>>;
// 성공하고 아무것도 리턴하고 싶지 않다면 이 데이터 형을 사용하면 된다.
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
