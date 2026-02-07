import 'package:flutter/material.dart';
import 'package:pipes/domain/board_controller.dart';
import 'package:pipes/domain/models/pipe.dart';
import 'package:pipes/presentation/widgets/game/pipe_tile.dart';
import 'package:pipes/presentation/widgets/game/status_bar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.size,
    super.key,
  });

  final int size;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BoardController controller = BoardController();

  @override
  void initState() {
    super.initState();
    controller.generateBoard(widget.size);
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logopotam Assignment'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Pipe>>(
        valueListenable: controller,
        builder: (final context, final grid, _) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusBar(
                  controller: BoardController(),
                ),
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: controller.size,
                        ),
                        itemCount: grid.length,
                        itemBuilder: (final context, final index) {
                          return PipeTile(
                            controller: controller,
                            index: index,
                            onPressed: () => controller.handleTap(index),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => controller.generateBoard(widget.size),
                  child: const Text('New Game'),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
