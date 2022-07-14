import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/error/failures_messages.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

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
      (Failure failure) async => _onErrorInputEitherUnboxing(emit),
      (int number) async => await _onSuccessInputEitherUnboxing(number, emit),
    );
  }

  void _onErrorInputEitherUnboxing(Emitter<NumberTriviaState> emit) {
    final error = Error(message: invalidInputFailureMessage);
    emit(error);
  }

  Future<void> _onSuccessInputEitherUnboxing(
    int number,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final params = Params(number: number);
    final failureOrTrivia = await getConcrete(params);
    _unboxTriviaEither(failureOrTrivia, emit);
  }

  void _unboxTriviaEither(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) {
    failureOrTrivia.fold(
      (Failure failure) => _onErrorTriviaEitherUnboxing(failure, emit),
      (NumberTrivia trivia) => _onSuccessTriviaEitherUnboxing(trivia, emit),
    );
  }

  void _onErrorTriviaEitherUnboxing(
    Failure failure,
    Emitter<NumberTriviaState> emit,
  ) async {
    final message = _mapFailureToMessage(failure);
    final errorState = Error(message: message);

    emit(errorState);
  }

  void _onSuccessTriviaEitherUnboxing(
    NumberTrivia trivia,
    Emitter<NumberTriviaState> emit,
  ) {
    final loadedState = Loaded(trivia: trivia);
    emit(loadedState);
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final failureOrTrivia = await getRandom(NoParams());
    emit(Loading());

    failureOrTrivia.fold(
      (failure) => _onErrorFailureOrTriviaFold(failure, emit),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  void _onErrorFailureOrTriviaFold(
    Failure failure,
    Emitter<NumberTriviaState> emit,
  ) {
    final message = _mapFailureToMessage(failure);
    final errorState = Error(message: message);

    emit(errorState);
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
