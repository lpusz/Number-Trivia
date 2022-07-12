import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

class TestNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

@GenerateMocks([TestNumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia useCase;
  late MockTestNumberTriviaRepository repository;

  setUp(() {
    repository = MockTestNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(repository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(
    text: 'test',
    number: tNumber,
  );

  test('should get trivia for the number from repository', () async {
    // Arrange
    when(repository.getConcreteNumberTrivia(any)).thenAnswer(
      (_) async => const Right(tNumberTrivia),
    );

    // Act
    const params = Params(number: tNumber);
    final result = await useCase(params);

    // Assert
    expect(result, const Right(tNumberTrivia));
    verify(repository.getConcreteNumberTrivia(params.number));
    verifyNoMoreInteractions(repository);
  });
}
