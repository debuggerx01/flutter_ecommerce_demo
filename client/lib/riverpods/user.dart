import 'package:ecommerce_demo/apis/models/user.dart' as user_info_model;
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:ecommerce_demo/riverpods/cart.dart';
import 'package:ecommerce_demo/riverpods/collection.dart';
import 'package:ecommerce_demo/riverpods/order.dart';
import 'package:ecommerce_demo/utils/sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@riverpod
class UserInfo extends _$UserInfo {
  @override
  FutureOr<user_info_model.UserInfo> build() async {
    if (ref.read(userIdProvider) == null) {
      return const user_info_model.UserInfo(uid: 0, mail: '游客@', balance: 0);
    }
    return ref.read(apiProvider).userInfo();
  }

  void updateBalance(int newBalance) {
    state = AsyncValue.data(user_info_model.UserInfo(
      uid: state.value!.uid,
      mail: state.value!.mail,
      balance: newBalance,
    ));
  }
}

@riverpod
class UserId extends _$UserId {
  @override
  int? build() {
    return sp.uid;
  }

  void clear() {
    sp.uid = null;
    state = null;
    ref.invalidate(collectionProvider);
    ref.invalidate(cartProvider);
    ref.invalidate(userInfoProvider);
    ref.invalidate(orderProvider);
    ref.invalidateSelf();
  }

  Future<void> login(String mail) async {
    var uid = await ref.read(apiProvider).login(mail: mail);
    state = uid;
    sp.uid = uid;
    ref.invalidate(collectionProvider);
    ref.invalidate(cartProvider);
    ref.invalidate(userInfoProvider);
    ref.invalidate(orderProvider);
    ref.invalidateSelf();
  }
}
