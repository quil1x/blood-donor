class UserModel {
  final String name;
  final String rank;
  final String avatarUrl;
  final int totalDonations;
  final int livesSaved;
  final int totalPoints;

  UserModel({
    required this.name,
    required this.rank,
    required this.avatarUrl,
    required this.totalDonations,
    required this.livesSaved,
    required this.totalPoints,
  });
}
