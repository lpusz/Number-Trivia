import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

class TestGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class TestGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class TestInputConverter extends Mock implements InputConverter {}


@GenerateMocks([
  TestGetConcreteNumberTrivia,
  TestGetRandomNumberTrivia,
  TestInputConverter,
])
void main() {
  late NumberTriviaBloc bloc;
  late MockTestGetConcreteNumberTrivia getConcrete;
  late MockTestGetRandomNumberTrivia getRandom;
  late MockTestInputConverter converter;

  setUp(() {
    getRandom = MockTestGetRandomNumberTrivia();
    getConcrete = MockTestGetConcreteNumberTrivia();
    converter = MockTestInputConverter();

    bloc = NumberTriviaBloc(
      getRandom: getRandom,
      getConcrete: getConcrete,
      converter: converter,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, Empty());
  });

  blocTest<NumberTriviaBloc, NumberTriviaState>(
    'TODO: description',
    build: () => NumberTriviaBloc(
      getRandom: getRandom,
      getConcrete: getConcrete,
      converter: converter,
    ),
  );
}
