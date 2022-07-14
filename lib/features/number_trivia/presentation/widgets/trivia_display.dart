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

    return SizedBox(
      height: height,
      child: Column(
        children: [
          _numberDisplay(),
          _descriptionDisplay(),
        ],
      ),
    );
  }

  Text _numberDisplay() {
    return Text(
      numberTrivia.number.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Expanded _descriptionDisplay() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            numberTrivia.text,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
