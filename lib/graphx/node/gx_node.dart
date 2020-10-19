class GxNode {
  GxNodePool _pool;
  bool isActive() => false;
  void setActive(bool flag) => false;
}

class GxNodePool {
  GxNode _first;
  GxNode _last;
  int _maxCount;
  int _cachedCount = 0;

  int get cachedCount => _cachedCount;

  GxNodePool([int maxCount = 0, int precacheCount = 0]) {
    _maxCount = 0;
    for (var i = 0; i < precacheCount; ++i) {
      _createNew(true);
    }
  }

  GxNode getNext() {
    GxNode node;
    if (_first == null || _first.isActive()) {
      node = _createNew(false);
    } else {
      node = _first;
      _putToBack(node);
      node.setActive(true);
    }
  }

  GxNode _poolNext;
  GxNode _poolPrev;

  void recycle(GxNode node, [bool reset = false]) {
    node.setActive(false);
    // bindprototype.
    _putToFront(node);
  }

  void _putToFront(GxNode node) {
    if (node == _first) return;
    node._poolNext?._poolPrev = node._poolPrev;
    node._poolPrev?._poolNext = node._poolNext;
    if (node == _last) _last = _last._poolPrev;
    if (_first != null) _first._poolPrev = node;
    node._poolPrev = null;
    node._poolNext = _first;
    _first = node;
  }

  void _putToBack(GxNode node) {
    if (node == _last) return;
    if (node._poolNext != null) node._poolNext._poolPrev = node._poolPrev;
    if (node._poolPrev != null) node._poolPrev._poolNext = node._poolNext;
    if (node == _first) _first = _first._poolNext;
    if (_last != null) _last._poolNext = node;
    node._poolPrev = _last;
    node._poolNext = null;
    _last = node;
  }

  GxNode _createNew([bool precache = false]) {
    GxNode node;
    if (_maxCount == 0 || _cachedCount < _maxCount) {
      _cachedCount++;

      /// prototype factory?!
      node = GxNode();
      if (precache) node.setActive(false);
      node._pool = this;
      if (_first == null) {
        _last = _first = node;
      } else {
        node._poolPrev = _last;
        _last._poolNext = node;
        _last = node;
      }
    }
    return node;
  }

  void dispose() {
    while (_first != null) {
      GxNode next = _first._poolNext;
      _first.dispose();
      _first = next;
    }
  }
}

///  GxNode _pool;
