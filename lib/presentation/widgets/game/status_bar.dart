import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipes/domain/board_controller.dart';
import 'package:pipes/domain/models/pipe.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({
    required this.controller,
    super.key,
  });

  final BoardController controller;

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(StatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.isVictory && !_scaleController.isAnimating) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 2,
      child: ValueListenableBuilder<List<Pipe>>(
        valueListenable: widget.controller,
        builder: (final context, final grid, _) {
          final bool isVictory = widget.controller.isVictory;
          final int score = widget.controller.score;

          if (isVictory) {
            return Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Victory!',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Score: $score',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 24,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Score: $score',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
