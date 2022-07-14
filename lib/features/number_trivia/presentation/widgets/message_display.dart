import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3;

    return SizedBox(
      height: height,
      child: Center(
        child: SingleChildScrollView(
          child: _text(),
        ),
      ),
    );
  }

  Text _text() {
    return Text(
      message,
      style: const TextStyle(fontSize: 25),
      textAlign: TextAlign.center,
    );
  }
}
