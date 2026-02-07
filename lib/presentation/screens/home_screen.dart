import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pipes/domain/models/difficulty.dart';
import 'package:pipes/presentation/screens/game_screen.dart';
import 'package:pipes/presentation/widgets/home/logo.dart';
import 'package:pipes/presentation/widgets/home/start_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 5),
          const Logo(),
          const Spacer(flex: 5),
          StartButtons(onPressed: start),
          const Spacer(),
        ],
      ),
    );
  }

  FutureOr<void> start(final Difficulty difficulty) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(size: difficulty.size),
      ),
    );
  }
}
