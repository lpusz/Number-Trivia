import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/remote_client.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

@Injectable(as: NumberTriviaRemoteDataSource)
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
