import 'package:hive/hive.dart';

part 'app_user_model.g.dart';

@HiveType(typeId: 0)
class AppUser extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password;

  @HiveField(2)
  late String name;

  @HiveField(3)
  int totalDonations;

  @HiveField(4)
  int livesSaved;

  @HiveField(5)
  int totalPoints;

  @HiveField(6)
  Map<String, DateTime> completedQuests;

  AppUser({
    required this.email,
    required this.password,
    required this.name,
    this.totalDonations = 0,
    this.livesSaved = 0,
    this.totalPoints = 0,
    Map<String, DateTime>? completedQuests,
  }) : completedQuests = completedQuests ?? {}; // ВИПРАВЛЕНО
}
