import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import 'number_trivia_remote_data_source_test.mocks.dart';

class DioRemoteClient extends Mock implements RemoteClient {}

@GenerateMocks([DioRemoteClient])
void main() {
  final tModel = NumberTriviaModel(text: 'test trivia', number: 1);

  late MockDioRemoteClient remoteClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    remoteClient = MockDioRemoteClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(remoteClient: remoteClient);
  });

  test('should get concrete number trivia', () async {
    // Arrange
    when(
      remoteClient.getConcreteNumberTrivia(1),
    ).thenAnswer(
      (_) async => tModel,
    );

    // Act
    dataSource.getConcreteNumberTrivia(1);

    // Assert
    verify(remoteClient.getConcreteNumberTrivia(1));
    verifyNoMoreInteractions(remoteClient);
  });

  test('should throws exception', () async {
    // Arrange
    when(
      remoteClient.getConcreteNumberTrivia(1),
    ).thenThrow(ServerException());

    // Act
    final call = dataSource.getConcreteNumberTrivia;

    // Assert
    expect(() => call(1), throwsA(const TypeMatcher<ServerException>()));
  });
}
