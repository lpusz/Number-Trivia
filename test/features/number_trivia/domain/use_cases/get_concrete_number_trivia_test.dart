import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart' as f_test;
import 'package:injectable/injectable.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/injection.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@Environment(Env.test)
@Injectable(as: NumberTriviaRepository)
class TestNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

@GenerateMocks([TestNumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia useCase;
  late MockTestNumberTriviaRepository repository;

  f_test.setUpAll(() {
    configureInjection(Env.test);
  });

  f_test.setUp(() {
    // TODO: Why this doesn't work? I want it
    // repository = getIt.get<NumberTriviaRepository>();
    repository = MockTestNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(repository);
  });

  const tNumber = 1;
  const tNUmberTrivia = NumberTrivia(text: 'test', number: tNumber);

  f_test.test('should get trivia for the number from', () async {
    // Arrange
    when(repository.getConcreteNumberTrivia(any)).thenAnswer(
      (_) async => const Right(tNUmberTrivia),
    );

    // Act
    final result = await useCase.execute(number: tNumber);

    // Assert
    f_test.expect(result, const Right(tNUmberTrivia));
    verify(repository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(repository);
  });
}
