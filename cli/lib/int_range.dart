enum RangeEdgeCondition { open, closed }

class IntRange {
  final int start;
  final int end;
  final RangeEdgeCondition startCondition;
  final RangeEdgeCondition endCondition;

  IntRange(this.start, this.end, this.startCondition, this.endCondition);

  IntRange.closed(this.start, this.end)
      : startCondition = RangeEdgeCondition.closed,
        endCondition = RangeEdgeCondition.closed;

  IntRange.open(this.start, this.end)
      : startCondition = RangeEdgeCondition.open,
        endCondition = RangeEdgeCondition.open;

  IntRange.closedOpen(this.start, this.end)
      : startCondition = RangeEdgeCondition.closed,
        endCondition = RangeEdgeCondition.open;

  IntRange.openClosed(this.start, this.end)
      : startCondition = RangeEdgeCondition.open,
        endCondition = RangeEdgeCondition.closed;

  bool contains(num number) {
    return switch (startCondition) {
          RangeEdgeCondition.open => start < number,
          RangeEdgeCondition.closed => start <= number,
        } &&
        switch (endCondition) {
          RangeEdgeCondition.open => number < end,
          RangeEdgeCondition.closed => number <= end
        };
  }
}
