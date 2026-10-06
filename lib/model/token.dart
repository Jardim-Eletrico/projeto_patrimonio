class Token {
  String access;
  String refresh;

  Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }
}