import 'package:ecommerce_demo/apis/models/user.dart' as UserInfoModel;
import 'package:ecommerce_demo/riverpods/apis.dart';
import 'package:ecommerce_demo/riverpods/cart.dart';
import 'package:ecommerce_demo/riverpods/collection.dart';
import 'package:ecommerce_demo/utils/sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@riverpod
class UserInfo extends _$UserInfo {
  @override
  FutureOr<UserInfoModel.UserInfo> build() async {
    if (ref.read(userIdProvider) == null) {
      return const UserInfoModel.UserInfo(uid: 0, mail: '游客@', balance: 0);
    }
    return ref.read(apiProvider).userInfo();
  }
}

@riverpod
class UserId extends _$UserId {
  @override
  int? build() {
    return sp.uid;
  }

  Future<void> login(String mail) async {
    var uid = await ref.read(apiProvider).login(mail: mail);
    state = uid;
    sp.uid = uid;
    ref.invalidate(collectionProvider);
    ref.invalidate(cartProvider);
    ref.invalidate(userInfoProvider);
    /// todo: orderProvider
  }
}
