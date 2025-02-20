enum RangeEdgeCondition { open, closed }

class IntRange {
  final int start;
  final int end;
  final RangeEdgeCondition startCondition;
  final RangeEdgeCondition endCondition;

  IntRange(this.start, this.end, this.startCondition, this.endCondition) {
    if (start > end) {
      throw Exception('start ($start) is bigger than end ($end)');
    }
  }

  IntRange.closed(int start, int end)
    : this(start, end, RangeEdgeCondition.closed, RangeEdgeCondition.closed);

  IntRange.open(int start, int end)
    : this(start, end, RangeEdgeCondition.open, RangeEdgeCondition.open);

  IntRange.closedOpen(int start, int end)
    : this(start, end, RangeEdgeCondition.closed, RangeEdgeCondition.open);

  IntRange.openClosed(int start, int end)
    : this(start, end, RangeEdgeCondition.open, RangeEdgeCondition.closed);

  IntRange.singleton(int number) : this.closed(number, number);

  bool contains(num number) {
    return switch (startCondition) {
          RangeEdgeCondition.open => start < number,
          RangeEdgeCondition.closed => start <= number,
        } &&
        switch (endCondition) {
          RangeEdgeCondition.open => number < end,
          RangeEdgeCondition.closed => number <= end,
        };
  }
}
