import 'package:shared_preferences/shared_preferences.dart';

/// 必须在启动app时初始化！！！
late final SharedPreferences prefs;

const _spUid = 'sp_key_uid';

const sp = _Sp._();

class _Sp {
  const _Sp._();

  int? get uid => prefs.getInt(_spUid);

  set uid(value) => value == null ? prefs.remove(_spUid) : prefs.setInt(_spUid, value);
}
