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
    final bloc = getIt<NumberTriviaBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: _body(bloc),
    );
  }

  BlocProvider<NumberTriviaBloc> _body(NumberTriviaBloc bloc) {
    return BlocProvider<NumberTriviaBloc>.value(
      value: bloc,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      children: const [
        SizedBox(height: 20),
        TriviaControls(),
        SizedBox(height: 20),
        TriviaBuilder(),
      ],
    );
  }
}
