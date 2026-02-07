import 'package:flutter/material.dart';
import 'package:pipes/domain/models/pipe.dart';
import 'package:pipes/domain/models/side.dart';

class PipePainter extends CustomPainter {
  PipePainter({
    required this.pipe,
    required this.inactiveColor,
    required this.activeColor,
    required this.terminatorActiveColor,
    required this.terminatorInativeColor,
    required this.starterColor,
  });

  final Pipe pipe;
  final Color inactiveColor;
  final Color activeColor;
  final Color terminatorActiveColor;
  final Color terminatorInativeColor;
  final Color starterColor;

  @override
  void paint(final Canvas canvas, final Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = pipe.isActivated ? activeColor : inactiveColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Draw lines
    for (var side in pipe.initialConnections) {
      final endpoint = switch (side) {
        Side.top => Offset(size.width / 2, 0),
        Side.right => Offset(size.width, size.height / 2),
        Side.bottom => Offset(size.width / 2, size.height),
        Side.left => Offset(0, size.height / 2),
      };
      canvas.drawLine(center, endpoint, paint);
    }

    // Draw specific markers based on sealed type
    switch (pipe) {
      case StarterPipe():
        canvas.drawCircle(center, 8, paint..color = starterColor);
        canvas.drawCircle(center, 3, Paint()..color = Colors.white);
      case TerminatorPipe():
        canvas.drawCircle(
          center,
          7,
          paint..color = pipe.isActivated ? terminatorActiveColor : terminatorInativeColor,
        );
      case MiddlePipe():
        canvas.drawCircle(center, 2, paint);
    }
  }

  @override
  bool shouldRepaint(final PipePainter old) => old.pipe != pipe;
}
