import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:retrofit/retrofit.dart' as retrofit;

part 'remote_client.g.dart';

@lazySingleton
@retrofit.RestApi(baseUrl: 'http://numbersapi.com/')
abstract class RemoteClient {
  @factoryMethod
  factory RemoteClient(Dio dio) = _RemoteClient;

  @retrofit.GET('/random')
  @retrofit.Headers(<String, dynamic>{
    'Content-Type': 'application/json',
  })
  Future<NumberTriviaModel> getRandomNumberTrivia();

  @retrofit.GET('/{number}')
  @retrofit.Headers(<String, dynamic>{
    'Content-Type': 'application/json',
  })
  Future<NumberTriviaModel> getConcreteNumberTrivia(
    @retrofit.Path('number') int number,
  );
}
