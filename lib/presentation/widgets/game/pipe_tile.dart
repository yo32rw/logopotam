// ignore_for_file: always_put_required_named_parameters_first

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pipes/domain/board_controller.dart';
import 'package:pipes/domain/models/pipe.dart';
import 'package:pipes/presentation/widgets/game/pipe_painter.dart';

class PipeTile extends StatelessWidget {
  const PipeTile({
    super.key,
    required this.controller,
    required this.index,
    required this.onPressed,
  });

  final BoardController controller;
  final int index;
  final void Function() onPressed;

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<List<Pipe>>(
      valueListenable: controller,
      builder: (final context, final grid, _) {
        final Pipe pipe = grid[index];
        return GestureDetector(
          onTap: () => onPressed(),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 100),
            tween: Tween(end: pipe.turns * (pi / 2)),
            builder: (final context, final angle, _) {
              return Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  painter: PipePainter(
                    pipe: pipe,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.green,
                    terminatorActiveColor: Colors.yellow.shade800,
                    terminatorInativeColor: Colors.amber.shade200,
                    starterColor: Colors.green,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
