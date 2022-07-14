import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';

class TriviaBuilder extends StatelessWidget {
  const TriviaBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      bloc: context.read<NumberTriviaBloc>(),
      builder: (context, state) {
        if (state is Empty) {
          return const MessageDisplay(message: 'Start searching!');
        } else if (state is Error) {
          return MessageDisplay(message: state.message);
        } else if (state is Loaded) {
          return TriviaDisplay(numberTrivia: state.trivia);
        } else if (state is Loading) {
          return const LoadingWidget();
        }

        return Container();
      },
    );
  }
}
