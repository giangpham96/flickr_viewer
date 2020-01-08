import 'dart:async';

extension StreamExtension<T> on StreamController<T> {

  void addIfNotClosed(T event) {
    if (isClosed)
      return;
    add(event);
  }
}
