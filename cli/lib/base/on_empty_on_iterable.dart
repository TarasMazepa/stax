extension OnEmptyOnIterable<T> on Iterable<T> {
  Iterable<T> onEmpty(void Function() onEmpty) {
    return OnEmptyIterable(this, onEmpty);
  }
}

class OnEmptyIterable<T> extends Iterable<T> {
  final Iterable<T> _source;
  final void Function() _onEmpty;

  OnEmptyIterable(this._source, this._onEmpty);

  @override
  Iterator<T> get iterator => OnEmptyIterator(_source.iterator, _onEmpty);
}

class OnEmptyIterator<T> implements Iterator<T> {
  final Iterator<T> _source;
  final void Function() _onEmpty;
  bool _hadElement = false;

  OnEmptyIterator(this._source, this._onEmpty);

  @override
  T get current => _source.current;

  @override
  bool moveNext() {
    if (_source.moveNext()) {
      _hadElement = true;
      return true;
    } else {
      if (!_hadElement) _onEmpty();
      return false;
    }
  }
}
