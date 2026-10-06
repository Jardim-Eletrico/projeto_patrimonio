class MetricasUsuarios {
  int activeRefreshTokens;
  int pendingResetCodes;
  int standardUsers;
  int totalAdmins;
  int totalProfessores;
  int totalUsers;

  MetricasUsuarios({
    required this.activeRefreshTokens,
    required this.pendingResetCodes,
    required this.standardUsers,
    required this.totalAdmins,
    required this.totalProfessores,
    required this.totalUsers,
  });

  factory MetricasUsuarios.fromJson(Map<String, dynamic> json) {
    return MetricasUsuarios(
      activeRefreshTokens: json['activeRefreshTokens'],
      pendingResetCodes: json['pendingResetCodes'],
      standardUsers: json['standardUsers'],
      totalAdmins: json['totalAdmins'],
      totalProfessores: json['totalProfessores'],
      totalUsers: json['totalUsers'],
    );
  }
}