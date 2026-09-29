class Token {
  String access;
  String refresh;

  Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      access: json['access'],
      refresh: json['refresh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }
}