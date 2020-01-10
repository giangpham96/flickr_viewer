import 'package:flutter_test/flutter_test.dart';

extension TestStream<T> on Stream<T> {
  Future<void> expect(StreamMatcher matcher) {
    return expectLater(this, matcher);
  }
}

extension TestFuture<T> on Future<T> {
  Future<void> expectValue(dynamic matcher) async {
    expect(await this, matcher);
  }

  Future<void> expectError(dynamic matcher) async {
    try {
      await this;
      fail("exception not thrown");
    } catch (e) {
      expect(e, matcher);
    }
  }
}
