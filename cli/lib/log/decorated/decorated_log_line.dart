import 'dart:math';

class DecoratedLogLine {
  final String branchName;
  final List<String> decorations;
  String? _decoration;

  String get decoration {
    return _decoration ??= (StringBuffer()..writeAll(decorations.reversed))
        .toString();
  }

  DecoratedLogLine(this.branchName, this.decorations);

  DecoratedLogLine withIndent(String indent) {
    decorations.add(indent);
    _decoration = null;
    return this;
  }

  int getMaxAlignment(int alignment) {
    return max(decoration.length, alignment);
  }

  void decorateToStringBuffer(int alignment, StringBuffer buffer) {
    buffer
      ..write(decoration)
      ..write(' ' * (alignment - decoration.length + 1))
      ..write(branchName);
  }

  @override
  String toString() {
    return '$decoration $branchName';
  }
}
