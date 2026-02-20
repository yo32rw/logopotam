import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pipes/domain/game_feedback_service.dart';
import 'package:pipes/domain/models/difficulty.dart';
import 'package:pipes/presentation/screens/game_screen.dart';
import 'package:pipes/presentation/widgets/home/logo.dart';
import 'package:pipes/presentation/widgets/home/sound_toggle_button.dart';
import 'package:pipes/presentation/widgets/home/start_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameFeedbackService _gameFeedbackService = GameFeedbackService();
  bool _isSoundEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SoundToggleButton(
                  isSoundEnabled: _isSoundEnabled,
                  onPressed: toggleSound,
                ),
              ],
            ),
          ),
          const Spacer(flex: 5),
          const Logo(),
          const Spacer(flex: 5),
          StartButtons(onPressed: start),
          const Spacer(),
        ],
      ),
    );
  }

  void toggleSound() {
    setState(() {
      _isSoundEnabled = !_isSoundEnabled;
    });
    _gameFeedbackService.setMusicEnabled(_isSoundEnabled);
  }

  FutureOr<void> start(final Difficulty difficulty) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(size: difficulty.size),
      ),
    );
  }

  @override
  void dispose() {
    _gameFeedbackService.unregisterScreen();
    super.dispose();
  }
}
