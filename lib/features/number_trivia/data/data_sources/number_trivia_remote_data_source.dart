import 'package:dio/dio.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:retrofit/retrofit.dart';

part 'number_trivia_remote_data_source.g.dart';

@RestApi(baseUrl: 'http://numbersapi.com/')
abstract class RemoteClient {
  factory RemoteClient(Dio dio, {String baseUrl}) = _RemoteClient;

  @GET('/random')
  Future<NumberTriviaModel> getRandomNumberTrivia();

  @GET('/{number}')
  Future<NumberTriviaModel> getConcreteNumberTrivia(@Path('number') int number);
}

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final RemoteClient remoteClient;

  NumberTriviaRemoteDataSourceImpl({
    required this.remoteClient,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    try {
      return await remoteClient.getConcreteNumberTrivia(number);
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    try {
      return await remoteClient.getRandomNumberTrivia();
    } on DioError catch (_) {
      throw ServerException();
    }
  }
}
