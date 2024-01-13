import 'package:ecommerce_demo/apis/models/category.dart';
import 'package:ecommerce_demo/apis/models/item.dart';
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_data.g.dart';

@riverpod
class HomeData extends _$HomeData {
  @override
  FutureOr<(List<Category>?, List<Item>, bool)> build() async => await ref.read(apiProvider).homeData();

  Future<void> loadMore() async {
    if (state.value?.$2.isEmpty == true) return;
    if (state.value?.$3 == false) return;

    var (_, items, hasMore) = await ref.read(apiProvider).homeData(
          lastItemId: state.value!.$2.last.id,
        );
    final (categories, oldItems, _) = await future;
    state = AsyncData(
      (categories, [...oldItems, ...items], hasMore),
    );
  }
}
