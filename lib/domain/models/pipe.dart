import 'package:pipes/domain/models/side.dart';

sealed class Pipe {
  const Pipe({
    required this.initialConnections,
    this.turns = 0,
    this.isActivated = false,
  });

  final Set<Side> initialConnections;
  final int turns;
  final bool isActivated;

  Set<Side> get currentConnections {
    return initialConnections.map((final side) {
      int index = (side.index + (turns % 4)) % 4;
      return Side.values[index];
    }).toSet();
  }

  Pipe copyWith({final int? turns, final bool? isActivated});
  Pipe rotate() => copyWith(turns: turns + 1);
  bool has(final Side side) => currentConnections.contains(side);
}

final class StarterPipe extends Pipe {
  StarterPipe({required final Side connection, super.turns, super.isActivated})
    : super(initialConnections: {connection});

  @override
  StarterPipe copyWith({final int? turns, final bool? isActivated}) {
    return StarterPipe(
      connection: initialConnections.first,
      turns: turns ?? this.turns,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}

final class MiddlePipe extends Pipe {
  const MiddlePipe({required super.initialConnections, super.turns, super.isActivated});

  @override
  MiddlePipe copyWith({final int? turns, final bool? isActivated}) {
    return MiddlePipe(
      initialConnections: initialConnections,
      turns: turns ?? this.turns,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}

final class TerminatorPipe extends Pipe {
  TerminatorPipe({required final Side connection, super.turns, super.isActivated})
    : super(initialConnections: {connection});

  @override
  TerminatorPipe copyWith({final int? turns, final bool? isActivated}) {
    return TerminatorPipe(
      connection: initialConnections.first,
      turns: turns ?? this.turns,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}
