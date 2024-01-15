import 'package:ecommerce_demo/apis/models/collection.dart' as collection_model;
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collection.g.dart';

@Riverpod(keepAlive: true)
class Collection extends _$Collection {
  @override
  FutureOr<List<collection_model.Collection>> build() async {
    return ref.read(apiProvider).collectionList();
  }

  Future<void> updateCollection({
    required int itemId,
  }) async {
    var resp = await ref.read(apiProvider).updateCollection(
      itemId: itemId,
    );
    print(resp);
    ref.invalidateSelf();
  }
}
