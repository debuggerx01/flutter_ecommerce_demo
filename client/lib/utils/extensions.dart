import 'package:flutter/material.dart';

extension CtxExtensions on BuildContext {
  ThemeData get t => Theme.of(this);

  NavigatorState get n => Navigator.of(this);

  Color get containerBgColor => switch (t.brightness) {
        Brightness.dark => t.colorScheme.onSurfaceVariant.withOpacity(0.1),
        Brightness.light => t.colorScheme.secondaryContainer.withOpacity(0.5),
      };

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

extension DateTimeExtensions on DateTime {
  String get cnString => '$year年$month月$day日 $hour:$minute:$second';
}
