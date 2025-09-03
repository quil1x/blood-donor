import 'package:hive/hive.dart';

// Цей файл буде згенеровано автоматично
part 'app_user_model.g.dart';

@HiveType(typeId: 0) // Унікальний typeId для кожної моделі
class AppUser extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password; // У реальному проєкті паролі потрібно хешувати!

  @HiveField(2)
  late String name;

  AppUser({
    required this.email,
    required this.password,
    required this.name,
  });
}