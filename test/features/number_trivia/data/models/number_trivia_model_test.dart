import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(
    number: 1,
    text: 'Test text',
  );

  test('should be a subclass of NumberTrivia entity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia.json'),
        );

        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // Assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is an double',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia_double.json'),
        );

        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // Assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containg a proper data', () async {
      // Act
      final result = tNumberTriviaModel.toJson();

      // Assert
      expect(result, {
        "text": "Test text",
        "number": 1,
      });
    });
  });
}
