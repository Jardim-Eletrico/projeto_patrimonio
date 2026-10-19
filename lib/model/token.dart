
class Token {
  String access;
  String refresh;

  Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      access: json['token'] as String,
      refresh: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': access,
      'refreshToken': refresh,
    };
  }
}
