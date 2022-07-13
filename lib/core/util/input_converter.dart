import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }

      return Right(integer);
    } on FormatException {
      final failure = InvalidInputFailure();
      return Left(failure);
    }
  }
}

class InvalidInputFailure extends Failure {}
