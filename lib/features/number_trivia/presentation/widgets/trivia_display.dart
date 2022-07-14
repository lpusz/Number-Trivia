import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    super.key,
    required this.numberTrivia,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3;

    return Column(
      children: [
        _numberDisplay(),
        const SizedBox(height: 10),
        _descriptionDisplay(),
      ],
    );
  }

  Widget _numberDisplay() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orangeAccent),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Text(
        numberTrivia.number.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _descriptionDisplay() {
    return Text(
      numberTrivia.text,
      style: const TextStyle(fontSize: 25),
      textAlign: TextAlign.center,
    );
  }
}
