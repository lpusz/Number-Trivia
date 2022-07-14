import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid input - The number must be a positive integer or zero.';

@injectable
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcrete;
  final GetRandomNumberTrivia getRandom;
  final InputConverter converter;

  @factoryMethod
  NumberTriviaBloc({
    required this.getRandom,
    required this.getConcrete,
    required this.converter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = converter.stringToUnsignedInteger(event.numberString);
    await _unboxInputEither(inputEither, emit);
  }

  Future<void> _unboxInputEither(
    Either<Failure, int> inputEither,
    Emitter<NumberTriviaState> emit,
  ) async {
    await inputEither.fold(
      (Failure failure) async => _emitInvalidInput(emit),
      (int number) async {
        emit(Loading());

        final params = Params(number: number);
        final failureOrTrivia = await getConcrete(params);
        await _unboxTriviaEither(failureOrTrivia, emit);
      },
    );
  }

  Future<void> _unboxTriviaEither(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) async {
    failureOrTrivia.fold(
      (Failure failure) {
        final errorState = Error(
          message: _mapFailureToMessage(failure),
        );
        emit(errorState);
      },
      (NumberTrivia trivia) {
        final loadedState = Loaded(trivia: trivia);
        emit(loadedState);
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final failureOrTrivia = await getRandom(NoParams());
    emit(Loading());

    failureOrTrivia.fold(
      (failure) {
        final errorState = Error(
          message: _mapFailureToMessage(failure),
        );
        emit(errorState);
      },
      (trivia) {
        emit(Loaded(trivia: trivia));
      },
    );
  }

  void _emitInvalidInput(Emitter<NumberTriviaState> emit) {
    final error = Error(message: invalidInputFailureMessage);
    emit(error);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
