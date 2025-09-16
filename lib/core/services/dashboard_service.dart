import 'package:flutter/foundation.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';

class DashboardService extends ChangeNotifier {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  final StaticAuthService _authService = StaticAuthService();

  int _totalDonations = 8;
  int _livesSaved = 24;
  int _totalPoints = 750;
  int _availableDonations = 2;

  int get totalDonations => _totalDonations;
  int get livesSaved => _livesSaved;
  int get totalPoints => _totalPoints;
  int get availableDonations => _availableDonations;

  void updateDonations(int donations) {
    _totalDonations = donations;
    _livesSaved = donations * 3;
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

  void addDonation() {
    _totalDonations++;
    _livesSaved = _totalDonations * 3;
    _totalPoints += 100;
    _availableDonations = 3 - (_totalDonations % 3);
    notifyListeners();
  }

  void resetData() {
    _totalDonations = 0;
    _livesSaved = 0;
    _totalPoints = 100;
    _availableDonations = 3;
    notifyListeners();
  }

  void setDemoData() {
    _totalDonations = 8;
    _livesSaved = 24;
    _totalPoints = 750;
    _availableDonations = 2;
    notifyListeners();
  }

  AppUser getCurrentData() {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
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

  void updateUserData(AppUser user) {
    _totalDonations = user.totalDonations;
    _livesSaved = user.livesSaved;
    _totalPoints = user.totalPoints;
    _availableDonations = 3 - (user.totalDonations % 3);
    notifyListeners();
  }
}
