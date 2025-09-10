import 'package:donor_dashboard/data/models/blood_center_model.dart';
import 'package:donor_dashboard/data/models/donation_model.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:donor_dashboard/data/models/reward_model.dart';

// Список квестів, розширений та збалансований
var mockQuests = [
  // Початкові квести
  QuestModel(
    id: "first_donation",
    title: "Перша донація",
    description: "Зареєструйте свою першу донацію в профілі",
    rewardPoints: 500,
    iconName: "drop_fill",
  ),
  QuestModel(
    id: "visit_blood_center",
    title: "Розвідник",
    description: "Заплануйте візит до будь-якого центру крові",
    rewardPoints: 150,
    iconName: "map_pin_ellipse",
  ),
  QuestModel(
    id: "invite_friend",
    title: "Запроси друга",
    description: "Запросіть друга стати донором",
    rewardPoints: 300,
    iconName: "person_2_fill",
  ),

  // Квести на кількість донацій
  QuestModel(
    id: "donor_adept",
    title: "Адепт донорства",
    description: "Зробіть 3 донації",
    rewardPoints: 1000,
    iconName: "flame_fill",
  ),
  QuestModel(
    id: "donor_expert",
    title: "Експерт донорства",
    description: "Зробіть 5 донацій",
    rewardPoints: 1500,
    iconName: "star_fill",
  ),
  QuestModel(
    id: "donor_master",
    title: "Майстер донорства",
    description: "Зробіть 10 донацій",
    rewardPoints: 3000,
    iconName: "shield_fill",
  ),

  // Соціальні та освітні квести
  QuestModel(
    id: "share_achievement",
    title: "Приклад для наслідування",
    description: "Поділіться своїм досягненням у соцмережах",
    rewardPoints: 200,
    iconName: "share_up",
  ),
  QuestModel(
    id: "read_article",
    title: "Допитливий розум",
    description: "Прочитайте статтю про користь донорства",
    rewardPoints: 100,
    iconName: "book_fill",
  ),
];

// --- Решта мок-даних без змін ---

class MockData {
  static List<QuestModel> get quests => mockQuests;
  static List<BloodCenterModel> get bloodCenters => mockBloodCenters;
  static List<RewardModel> get rewards => mockRewards;
}

final mockBloodCenters = [
  BloodCenterModel(
    id: "kyiv_center",
    name: "Київський міський центр крові",
    address: "вул. Максима Берлинського, 12",
    workingHours: "Пн-Пт: 08:00 - 16:00",
    phone: "+380 44 440 6533",
    latitude: 50.4725,
    longitude: 30.4485,
  ),
  BloodCenterModel(
    id: "lviv_center",
    name: "Львівський обласний центр служби крові",
    address: "вул. Пекарська, 65",
    workingHours: "Пн-Пт: 09:00 - 15:00",
    phone: "+380 32 276 2500",
    latitude: 49.8357,
    longitude: 24.0492,
  ),
  BloodCenterModel(
    id: "odessa_center",
    name: "Одеська обласна станція переливання крові",
    address: "Бісквітний пров., 2/3",
    workingHours: "Пн-Пт: 08:30 - 14:00",
    phone: "+380 48 776 0467",
    latitude: 46.4447,
    longitude: 30.7410,
  ),
  BloodCenterModel(
    id: "kharkiv_center",
    name: "Харківський обласний центр крові",
    address: "пр. Науки, 4",
    workingHours: "Пн-Пт: 08:00 - 15:00",
    phone: "+380 57 700 4000",
    latitude: 49.9935,
    longitude: 36.2304,
  ),
  BloodCenterModel(
    id: "dnipro_center",
    name: "Дніпровський міський центр крові",
    address: "вул. Шевченка, 31",
    workingHours: "Пн-Пт: 09:00 - 16:00",
    phone: "+380 56 377 7777",
    latitude: 48.4647,
    longitude: 35.0462,
  ),
  BloodCenterModel(
    id: "zaporizhzhia_center",
    name: "Запорізький обласний центр крові",
    address: "вул. Соборна, 160",
    workingHours: "Пн-Пт: 08:30 - 14:30",
    phone: "+380 61 233 3333",
    latitude: 47.8388,
    longitude: 35.1396,
  ),
  BloodCenterModel(
    id: "ivano_frankivsk_center",
    name: "Івано-Франківський обласний центр крові",
    address: "вул. Грушевського, 1",
    workingHours: "Пн-Пт: 08:00 - 15:00",
    phone: "+380 342 555 555",
    latitude: 48.9226,
    longitude: 24.7111,
  ),
  BloodCenterModel(
    id: "ternopil_center",
    name: "Тернопільський обласний центр крові",
    address: "вул. Руська, 10",
    workingHours: "Пн-Пт: 09:00 - 15:00",
    phone: "+380 352 123 456",
    latitude: 49.5535,
    longitude: 25.5948,
  ),
];

final mockRewards = [
  RewardModel(
    id: "blood_analysis",
    title: "Безкоштовний аналіз крові",
    description: "Повний біохімічний аналіз",
    cost: 2000,
    iconName: "science_outlined",
  ),
  RewardModel(
    id: "cinema_ticket",
    title: "Квиток в кіно",
    description: "На будь-який сеанс у мережі",
    cost: 1500,
    iconName: "ticket_fill",
  ),
  RewardModel(
    id: "gym_certificate",
    title: "Сертифікат у спортзал",
    description: "Місячний абонемент",
    cost: 5000,
    iconName: "fitness_center",
  ),
  RewardModel(
    id: "coffee",
    title: "Чашка кави",
    description: "Безкоштовна кава у партнера",
    cost: 500,
    iconName: "coffee",
  ),
];

final mockDonationHistory = [
  DonationModel(
      date: DateTime(2025, 5, 20), location: "Київський міський центр крові"),
  DonationModel(
      date: DateTime(2025, 2, 15), location: "Київський міський центр крові"),
  DonationModel(
      date: DateTime(2024, 11, 10), location: "Львівський обласний центр"),
];
