import 'package:flutter_test/flutter_test.dart';

extension TestStream<T> on Stream<T> {
  Future<void> expect(StreamMatcher matcher) {
    return expectLater(this, matcher);
  }
}
