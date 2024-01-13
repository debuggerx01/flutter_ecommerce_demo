import 'package:ecommerce_demo/apis/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apis.g.dart';

@riverpod
Apis api(ApiRef ref) {
  return Apis(reader: ref.read);
}

