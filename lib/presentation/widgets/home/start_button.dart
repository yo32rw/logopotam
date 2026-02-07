import 'package:flutter/material.dart';
import 'package:pipes/domain/models/difficulty.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    required this.onPressed,
    required this.difficulty,
    super.key,
  });

  final VoidCallback onPressed;
  final Difficulty difficulty;

  @override
  Widget build(final BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(
        switch (difficulty) {
          Difficulty.easy => 'Easy',
          Difficulty.medium => 'Medium',
          Difficulty.hard => 'Hard',
        },
      ),
    );
  }
}
