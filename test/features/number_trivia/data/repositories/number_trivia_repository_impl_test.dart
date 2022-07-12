import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

class RemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class LocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class TestNetworkInfo extends Mock implements NetworkInfo {}

@GenerateMocks([RemoteDataSource, LocalDataSource, TestNetworkInfo])
void main() {
  late NumberTriviaRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockTestNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockTestNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tModel = NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tModel;

    test('should check if the device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => tModel,
      );

      // Act
      repository.getConcreteNumberTrivia(tNumber);

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => tModel,
          );

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // 'equals' added for explicitly, not any special functionality
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => tModel,
          );

          // Act
          await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tModel));
        },
      );

      test(
        'should throw server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(
            ServerException(),
          );

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // 'equals' added for explicitly, not any special functionality
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tModel);

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tModel = NumberTriviaModel(text: 'test trivia', number: 123);
    final NumberTrivia tNumberTrivia = tModel;

    test('should check if the device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
        (_) async => tModel,
      );

      // Act
      repository.getRandomNumberTrivia();

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (_) async => tModel,
          );

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // 'equals' added for explicitly, not any special functionality
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (_) async => tModel,
          );

          // Act
          await repository.getRandomNumberTrivia();

          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tModel));
        },
      );

      test(
        'should throw server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(
            ServerException(),
          );

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // 'equals' added for explicitly, not any special functionality
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tModel);

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
