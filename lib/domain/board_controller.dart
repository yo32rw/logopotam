import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pipes/domain/models/pipe.dart';
import 'package:pipes/domain/models/side.dart';

class BoardController extends ChangeNotifier implements ValueListenable<List<Pipe>> {
  BoardController() {
    _gridNotifier = ValueNotifier<List<Pipe>>([]);
  }

  static final Random _kRandom = Random.secure();

  late final ValueNotifier<List<Pipe>> _gridNotifier;

  int get size => sqrt(_gridNotifier.value.length).toInt();

  bool get isVictory =>
      _gridNotifier.value.whereType<TerminatorPipe>().every((final p) => p.isActivated);

  int get interactions => _interactions;
  int _interactions = 0;

  int get maxScore => _gridNotifier.value.length * 2 * 1000;

  int get score => max(0, maxScore - interactions * 100);

  @override
  List<Pipe> get value => _gridNotifier.value;

  @override
  void addListener(final VoidCallback listener) => _gridNotifier.addListener(listener);

  @override
  void removeListener(final VoidCallback listener) => _gridNotifier.removeListener(listener);

  void generateBoard(final int size) {
    _interactions = 0;
    List<Set<Side>> raw = List.generate(size * size, (_) => {});

    Set<int> visited = {_kRandom.nextInt(size * size)};
    List<int> stack = [visited.first];

    while (visited.length < size * size) {
      int curr = stack.last;
      List<int> neighbors = _getUnvisitedNeighbors(size, curr, visited);

      if (neighbors.isNotEmpty) {
        neighbors.shuffle(_kRandom);
        int next = neighbors.first;
        Side s = _getSide(size, curr, next);
        raw[curr].add(s);
        raw[next].add(_mirror(s));
        visited.add(next);
        stack.add(next);
      } else {
        stack.removeLast();
        if (stack.isEmpty && visited.length < size * size) {
          generateBoard(size);
          return;
        }
      }
    }

    List<int> getLeaves() => [
      for (int i = 0; i < raw.length; i++)
        if (raw[i].length == 1) i,
    ];

    List<int> currentLeaves = getLeaves();

    while (currentLeaves.length > size + 1) {
      currentLeaves.shuffle(_kRandom);
      int leafToHeal = currentLeaves.first;

      bool healed = false;
      List<Side> dirs = Side.values.toList()..shuffle(_kRandom);
      for (var s in dirs) {
        int nx = (leafToHeal % size) + (s == Side.right ? 1 : (s == Side.left ? -1 : 0));
        int ny = (leafToHeal ~/ size) + (s == Side.bottom ? 1 : (s == Side.top ? -1 : 0));

        if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
          int nIdx = ny * size + nx;
          if (!raw[leafToHeal].contains(s) && raw[nIdx].length < 3) {
            raw[leafToHeal].add(s);
            raw[nIdx].add(_mirror(s));
            healed = true;
            break;
          }
        }
      }

      if (!healed) {
        generateBoard(size);
        return;
      }
      currentLeaves = getLeaves();
    }
    if (currentLeaves.length != size + 1) {
      generateBoard(size);
      return;
    }

    currentLeaves.shuffle(_kRandom);
    int srcIdx = currentLeaves.removeAt(0);
    Set<int> lampIdx = currentLeaves.toSet();

    _gridNotifier.value = List.generate(size * size, (final i) {
      Pipe p;
      if (i == srcIdx) {
        p = StarterPipe(connection: raw[i].first);
      } else if (lampIdx.contains(i)) {
        p = TerminatorPipe(connection: raw[i].first);
      } else {
        p = MiddlePipe(initialConnections: raw[i]);
      }
      return p.copyWith(turns: _kRandom.nextInt(4));
    });

    updateFlow(size);
  }

  List<int> _getUnvisitedNeighbors(final int size, final int i, final Set<int> visited) {
    List<int> res = [];
    final int x = i % size;
    final int y = i ~/ size;
    if (x > 0 && !visited.contains(i - 1)) res.add(i - 1);
    if (x < size - 1 && !visited.contains(i + 1)) res.add(i + 1);
    if (y > 0 && !visited.contains(i - size)) res.add(i - size);
    if (y < size - 1 && !visited.contains(i + size)) res.add(i + size);
    return res;
  }

  Side _getSide(final int size, final int curr, final int next) {
    if (next == curr + 1) return Side.right;
    if (next == curr - 1) return Side.left;
    if (next == curr + size) return Side.bottom;
    return Side.top;
  }

  Side _mirror(final Side s) => switch (s) {
    Side.top => Side.bottom,
    Side.bottom => Side.top,
    Side.left => Side.right,
    Side.right => Side.left,
  };

  void handleTap(final int i) {
    if (isVictory) return;
    _interactions++;
    final list = List<Pipe>.from(_gridNotifier.value);
    list[i] = list[i].rotate();
    _gridNotifier.value = list;
    final int size = sqrt(list.length).toInt();
    updateFlow(size);
  }

  void updateFlow(final int size) {
    var grid = _gridNotifier.value.map((final p) => p.copyWith(isActivated: false)).toList();
    int start = grid.indexWhere((final p) => p is StarterPipe);
    List<int> q = [start];
    grid[start] = grid[start].copyWith(isActivated: true);

    while (q.isNotEmpty) {
      int curr = q.removeAt(0);
      for (var s in Side.values) {
        if (grid[curr].has(s)) {
          int nx = (curr % size) + (s == Side.right ? 1 : (s == Side.left ? -1 : 0));
          int ny = (curr ~/ size) + (s == Side.bottom ? 1 : (s == Side.top ? -1 : 0));
          if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
            int nIdx = ny * size + nx;
            if (!grid[nIdx].isActivated && grid[nIdx].has(_mirror(s))) {
              grid[nIdx] = grid[nIdx].copyWith(isActivated: true);
              q.add(nIdx);
            }
          }
        }
      }
    }
    _gridNotifier.value = grid;
  }
}
