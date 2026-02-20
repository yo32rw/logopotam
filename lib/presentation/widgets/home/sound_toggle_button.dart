import 'package:flutter/material.dart';

class SoundToggleButton extends StatelessWidget {
  final bool isSoundEnabled;
  final VoidCallback onPressed;

  const SoundToggleButton({
    required this.isSoundEnabled,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSoundEnabled ? Icons.volume_up : Icons.volume_off,
      ),
      onPressed: onPressed,
    );
  }
}
