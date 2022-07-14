import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputStr;

  @override
  void initState() {
    super.initState();
    inputStr = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _textField(),
        const SizedBox(height: 10),
        _buttons(),
      ],
    );
  }

  TextField _textField() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Input a number',
      ),
      onChanged: _onChanged,
    );
  }

  void _onChanged(String value) {
    setState(() {
      inputStr = value;
    });
  }

  Row _buttons() {
    return Row(
      children: [
        _searchButton(),
        const SizedBox(width: 10),
        _randomButton(),
      ],
    );
  }

  Expanded _randomButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: dispatchRandom,
        child: const Text('Get random trivia'),
      ),
    );
  }

  Expanded _searchButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: dispatchConcrete,
        child: const Text('Search'),
      ),
    );
  }

  void dispatchRandom() {
    final bloc = context.read<NumberTriviaBloc>();
    bloc.add(GetTriviaForRandomNumber());
  }

  void dispatchConcrete() {
    final bloc = context.read<NumberTriviaBloc>();
    bloc.add(GetTriviaForConcreteNumber(inputStr));
  }
}
