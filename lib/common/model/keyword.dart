import 'package:flutter/foundation.dart';

class Keyword {
  final String keyword;
  final List<Keyword> subKeywords;

  const Keyword(this.keyword, {this.subKeywords});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Keyword &&
              runtimeType == other.runtimeType &&
              keyword == other.keyword &&
              listEquals(subKeywords, other.subKeywords);

  @override
  int get hashCode =>
      keyword.hashCode ^
      subKeywords.hashCode;


}
