import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/failures.dart';

@lazySingleton
class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String text) {
    try {
      return _parse(text);
    } on FormatException {
      final failure = InvalidInputFailure();
      return Left(failure);
    }
  }

  Right<Failure, int> _parse(String text) {
    final integer = int.parse(text);
    if (integer < 0) {
      throw const FormatException();
    }

    return Right(integer);
  }
}

class InvalidInputFailure extends Failure {}
