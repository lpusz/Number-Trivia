import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_builder.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:number_trivia/injection.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider<NumberTriviaBloc>.value(
        value: getIt<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildColumn(),
        ),
      ),
    );
  }

  Column _buildColumn() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        TriviaBuilder(),
        SizedBox(height: 20),
        TriviaControls(),
      ],
    );
  }
}
