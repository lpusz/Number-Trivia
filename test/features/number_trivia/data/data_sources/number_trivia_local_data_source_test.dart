import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

class TestSharedPreferences extends Mock implements SharedPreferences {}

@GenerateMocks([TestSharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockTestSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockTestSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_cached.json')),
    );

    test(
      'should return number trivia from shared preferences when there is one in the cache',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(
          fixture('trivia_cached.json'),
        );

        // Act
        final result = await dataSource.getLastNumberTrivia();

        // Assert
        verify(mockSharedPreferences.getString(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw cache exception where there is not a cached value',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // Act
        final call = dataSource.getLastNumberTrivia;

        // Assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );

    test('should call SharedPreferences to cache the data', () async {
      // Arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer(
        (_) async => true,
      );

      // Act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      // Assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        cachedNumberTrivia,
        expectedJsonString,
      ));
    });
  });
}
