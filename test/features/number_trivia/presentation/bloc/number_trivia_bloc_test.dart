import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

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
  late NumberTrivia expectedTrivia;

  setUp(() {
    getRandom = MockTestGetRandomNumberTrivia();
    getConcrete = MockTestGetConcreteNumberTrivia();
    converter = MockTestInputConverter();
    expectedTrivia = const NumberTrivia(number: 1, text: 'test trivia');
    bloc = NumberTriviaBloc(
      getRandom: getRandom,
      getConcrete: getConcrete,
      converter: converter,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, Empty());
  });

  group('get concrete trivia tests', () {
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should call the input converter to validate '
      'and convert the string on an unsigned integer',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          const Right(1),
        );

        when(getConcrete(any)).thenAnswer(
          (_) async => Right(expectedTrivia),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      verify: (_) {
        verify(converter.stringToUnsignedInteger('1'));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          Left(InvalidInputFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      expect: () => [
        isA<Error>().having(
          (state) => state.message,
          'should have input failure message',
          invalidInputFailureMessage,
        )
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from concrete use case',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          const Right(1),
        );
        when(getConcrete(any)).thenAnswer(
          (_) async => Right(expectedTrivia),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      verify: (_) {
        verify(getConcrete(const Params(number: 1)));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          const Right(1),
        );
        when(getConcrete(any)).thenAnswer(
          (_) async => Right(expectedTrivia),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      verify: (_) {
        verify(getConcrete(const Params(number: 1)));
      },
      expect: () => [
        isA<Loading>(),
        isA<Loaded>().having(
          (state) => state.trivia,
          'should have correct trivia',
          expectedTrivia,
        ),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          const Right(1),
        );
        when(getConcrete(any)).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      verify: (_) {
        verify(getConcrete(const Params(number: 1)));
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>().having(
          (state) => state.message,
          'should have serverFailureMessage message',
          serverFailureMessage,
        ),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error'
      'when getting data fails',
      setUp: () {
        when(converter.stringToUnsignedInteger(any)).thenReturn(
          const Right(1),
        );
        when(getConcrete(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForConcreteNumber('1'),
      ),
      verify: (_) {
        verify(getConcrete(const Params(number: 1)));
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>().having(
          (state) => state.message,
          'should have cacheFailureMessage message',
          cacheFailureMessage,
        ),
      ],
    );
  });

  group('get random trivia tests', () {
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from concrete use case',
      setUp: () {
        when(getRandom(any)).thenAnswer(
          (_) async => Right(expectedTrivia),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForRandomNumber(),
      ),
      verify: (_) {
        verify(getRandom(any));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten',
      setUp: () {
        when(getRandom(any)).thenAnswer(
          (_) async => Right(expectedTrivia),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForRandomNumber(),
      ),
      verify: (_) {
        verify(getRandom(any));
      },
      expect: () => [
        isA<Loading>(),
        isA<Loaded>().having(
          (state) => state.trivia,
          'should have correct trivia',
          expectedTrivia,
        ),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      setUp: () {
        when(getRandom(any)).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForRandomNumber(),
      ),
      verify: (_) {
        verify(getRandom(any));
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>().having(
          (state) => state.message,
          'should have serverFailureMessage message',
          serverFailureMessage,
        ),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error'
      'when getting data fails',
      setUp: () {
        when(getRandom(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getRandom: getRandom,
        getConcrete: getConcrete,
        converter: converter,
      ),
      act: (bloc) => bloc.add(
        GetTriviaForRandomNumber(),
      ),
      verify: (_) {
        verify(getRandom(any));
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>().having(
          (state) => state.message,
          'should have cacheFailureMessage message',
          cacheFailureMessage,
        ),
      ],
    );
  });
}
