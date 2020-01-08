import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double getScreenHeight() => MediaQuery.of(this).size.height;
}
