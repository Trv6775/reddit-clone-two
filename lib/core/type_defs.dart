import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_two/core/failure.dart';

typedef FutureEither<T>=Future<Either<Failure,T>>;
typedef FutureVoid=FutureEither<void>;