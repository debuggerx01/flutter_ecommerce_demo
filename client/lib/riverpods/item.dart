import 'package:ecommerce_demo/apis/models/item.dart';
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item.g.dart';

@Riverpod(keepAlive: true)
class ItemsData extends _$ItemsData {
  @override
  FutureOr<(List<Item>, bool)> build(int categoryId) async => ref.read(apiProvider).items(
        categoryId: categoryId,
      );

  Future<void> loadMore() async {
    if (state.value?.$1.isEmpty == true) return;
    if (state.value?.$2 == false) return;

    var (items, hasMore) = await ref.read(apiProvider).items(
          categoryId: categoryId,
          lastItemId: state.value!.$1.last.id,
        );
    final (oldItems, _) = await future;
    state = AsyncData(
      ([...oldItems, ...items], hasMore),
    );
  }
}

@riverpod
Future<Item> itemDetail(ItemDetailRef ref, int itemId) async => ref.read(apiProvider).itemDetail(itemId: itemId);
