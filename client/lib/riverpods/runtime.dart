import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'runtime.g.dart';

enum ScreenPatterns {
  desktop,
  mobile,
}

@riverpod
class CurrentScreenPattern extends _$CurrentScreenPattern {
  @override
  ScreenPatterns build() {
    return ScreenPatterns.mobile;
  }

  void update(ScreenPatterns pattern) => state = pattern;
}
