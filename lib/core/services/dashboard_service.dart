import 'package:flutter/foundation.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';

class DashboardService extends ChangeNotifier {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  final StaticAuthService _authService = StaticAuthService();

  // Фіксовані дані для дашборду
  int _totalDonations = 8;
  int _livesSaved = 24;
  int _totalPoints = 750;
  int _availableDonations = 2;

  // Геттери
  int get totalDonations => _totalDonations;
  int get livesSaved => _livesSaved;
  int get totalPoints => _totalPoints;
  int get availableDonations => _availableDonations;

  // Методи для оновлення даних
  void updateDonations(int donations) {
    _totalDonations = donations;
    _livesSaved = donations * 3; // Кожна донація рятує 3 життя
    notifyListeners();
  }

  void updatePoints(int points) {
    _totalPoints = points;
    notifyListeners();
  }

  void updateAvailableDonations(int available) {
    _availableDonations = available;
    notifyListeners();
  }

  // Метод для додавання донації
  void addDonation() {
    _totalDonations++;
    _livesSaved = _totalDonations * 3;
    _totalPoints += 100; // За кожну донацію +100 балів
    _availableDonations = 3 - (_totalDonations % 3); // Доступно донацій
    notifyListeners();
  }

  // Метод для скидання даних
  void resetData() {
    _totalDonations = 0;
    _livesSaved = 0;
    _totalPoints = 100;
    _availableDonations = 3;
    notifyListeners();
  }

  // Метод для встановлення демо-даних
  void setDemoData() {
    _totalDonations = 8;
    _livesSaved = 24;
    _totalPoints = 750;
    _availableDonations = 2;
    notifyListeners();
  }

  // Отримання поточних даних як AppUser
  AppUser getCurrentData() {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // Якщо є поточний користувач, використовуємо його дані
      return AppUser(
        id: currentUser.id,
        name: currentUser.name,
        email: currentUser.email,
        password: currentUser.password,
        totalDonations: currentUser.totalDonations,
        livesSaved: currentUser.livesSaved,
        totalPoints: currentUser.totalPoints,
        completedQuests: currentUser.completedQuests,
      );
    } else {
      // Якщо немає поточного користувача, використовуємо демо-дані
      return AppUser(
        id: 'dashboard',
        name: 'Демо Користувач',
        email: 'demo@example.com',
        password: 'demo',
        totalDonations: _totalDonations,
        livesSaved: _livesSaved,
        totalPoints: _totalPoints,
        completedQuests: {},
      );
    }
  }

  // Синхронізація з поточним користувачем
  void syncWithCurrentUser() {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      _totalDonations = currentUser.totalDonations;
      _livesSaved = currentUser.livesSaved;
      _totalPoints = currentUser.totalPoints;
      _availableDonations = 3 - (currentUser.totalDonations % 3);
      notifyListeners();
    }
  }

  // Оновлення даних користувача
  void updateUserData(AppUser user) {
    _totalDonations = user.totalDonations;
    _livesSaved = user.livesSaved;
    _totalPoints = user.totalPoints;
    _availableDonations = 3 - (user.totalDonations % 3);
    notifyListeners();
  }
}
