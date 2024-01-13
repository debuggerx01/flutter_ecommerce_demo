import 'package:flutter/material.dart';

extension CtxExtensions on BuildContext {
  ThemeData get t => Theme.of(this);

  NavigatorState get n => Navigator.of(this);

  go({required Widget Function(BuildContext) builder}) => n.push(
        MaterialPageRoute(builder: builder),
      );
}

extension StrExtensions on String {
  String get nameFromMail => split('@').first;
}

extension IntExtensions on int {
  String get priceStr => (this / 100).toStringAsFixed(2);

  String get priceStrWithUnit => '￥$priceStr';
}
