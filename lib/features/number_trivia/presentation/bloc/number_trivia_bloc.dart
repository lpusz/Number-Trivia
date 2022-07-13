import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/injection.dart';

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

  void _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = converter.stringToUnsignedInteger(event.numberString);
    inputEither.fold(
      (Failure failure) => _emitInvalidInput(emit),
      (int number) async => await _tryDownloadTrivia(emit, number),
    );
  }

  void _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final failureOrTrivia = await getRandom(NoParams());
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

  Future<void> _tryDownloadTrivia(
    Emitter<NumberTriviaState> emit,
    int number,
  ) async {
    emit(Loading());

    final params = Params(number: number);
    final failureOrTrivia = await getConcrete(params);
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
