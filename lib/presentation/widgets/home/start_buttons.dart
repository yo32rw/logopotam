import 'package:flutter/material.dart';
import 'package:pipes/domain/models/difficulty.dart';
import 'package:pipes/presentation/widgets/home/start_button.dart';

class StartButtons extends StatelessWidget {
  const StartButtons({
    required this.onPressed,
    super.key,
  });

  final void Function(Difficulty difficulty) onPressed;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ...Difficulty.values.map(
          (final difficulty) {
            return StartButton(
              difficulty: difficulty,
              onPressed: () => onPressed(difficulty),
            );
          },
        ),
      ],
    );
  }
}
