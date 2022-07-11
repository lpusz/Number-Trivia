import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

import 'get_random_number_trivia_test.mocks.dart';

class TestNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

@GenerateMocks([TestNumberTriviaRepository])
void main() {
  late GetRandomNumberTrivia useCase;
  late MockTestNumberTriviaRepository repository;

  setUp(() {
    repository = MockTestNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(repository);
  });

  const tNumberTrivia = NumberTrivia(
    text: 'test',
    number: 4,
  );

  test('should get trivia the number from repository', () async {
    // Arrange
    when(repository.getRandomNumberTrivia()).thenAnswer(
      (_) async => const Right(tNumberTrivia),
    );

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result, const Right(tNumberTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
