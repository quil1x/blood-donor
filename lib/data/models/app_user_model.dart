// lib/data/models/app_user_model.dart

class AppUser {
  final String id;
  final String name;
  final String email;
  int totalDonations;
  int livesSaved;
  int totalPoints;
  Map<String, DateTime> completedQuests;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.totalDonations = 0,
    this.livesSaved = 0,
    this.totalPoints = 100,
    Map<String, DateTime>? completedQuests,
  }) : completedQuests = completedQuests ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'totalDonations': totalDonations,
      'livesSaved': livesSaved,
      'totalPoints': totalPoints,
      'completedQuests': completedQuests
          .map((key, value) => MapEntry(key, value.toIso8601String())),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      totalDonations: json['totalDonations'] ?? 0,
      livesSaved: json['livesSaved'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      completedQuests: (json['completedQuests'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, DateTime.parse(value as String)),
          ) ??
          {},
    );
  }
}
