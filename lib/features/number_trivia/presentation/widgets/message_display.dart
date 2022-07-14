import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3;

    return SizedBox(
      // height: height,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(64),
            decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: _text(),
          ),
        ),
      ),
    );
  }

  Text _text() {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
