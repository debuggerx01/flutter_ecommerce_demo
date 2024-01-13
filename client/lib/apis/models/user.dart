class UserInfo {
  final int uid;
  final String mail;
  final int balance;

  const UserInfo({
    required this.uid,
    required this.mail,
    required this.balance,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        uid: json['id'] as int,
        mail: json['mail'] as String,
        balance: json['balance'] as int,
      );
}
