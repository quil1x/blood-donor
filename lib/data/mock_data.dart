import 'package:donor_dashboard/data/models/blood_center_model.dart';
import 'package:donor_dashboard/data/models/donation_model.dart';
// --- ВИПРАВЛЕНО: Правильний шлях до файлу ---
import 'package:donor_dashboard/data/models/quest_model.dart';
// --- КІНЕЦЬ ---
import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Список квестів, розширений та збалансований
var mockQuests = [
  // Початкові квести
  QuestModel(
    id: "first_donation",
    title: "Перша донація",
    description: "Зареєструйте свою першу донацію в профілі",
    rewardPoints: 500,
    icon: CupertinoIcons.drop_fill,
  ),
  QuestModel(
    id: "visit_blood_center",
    title: "Розвідник",
    description: "Заплануйте візит до будь-якого центру крові",
    rewardPoints: 150,
    icon: CupertinoIcons.map_pin_ellipse,
  ),
  QuestModel(
    id: "invite_friend",
    title: "Запроси друга",
    description: "Запросіть друга стати донором",
    rewardPoints: 300,
    icon: CupertinoIcons.person_2_fill,
  ),

  // Квести на кількість донацій
  QuestModel(
    id: "donor_adept",
    title: "Адепт донорства",
    description: "Зробіть 3 донації",
    rewardPoints: 1000,
    icon: CupertinoIcons.flame_fill,
  ),
  QuestModel(
    id: "donor_expert",
    title: "Експерт донорства",
    description: "Зробіть 5 донацій",
    rewardPoints: 1500,
    icon: CupertinoIcons.star_fill,
  ),
  QuestModel(
    id: "donor_master",
    title: "Майстер донорства",
    description: "Зробіть 10 донацій",
    rewardPoints: 3000,
    icon: CupertinoIcons.shield_fill,
  ),

  // Соціальні та освітні квести
  QuestModel(
    id: "share_achievement",
    title: "Приклад для наслідування",
    description: "Поділіться своїм досягненням у соцмережах",
    rewardPoints: 200,
    icon: CupertinoIcons.share_up,
  ),
  QuestModel(
    id: "read_article",
    title: "Допитливий розум",
    description: "Прочитайте статтю про користь донорства",
    rewardPoints: 100,
    icon: CupertinoIcons.book_fill,
  ),
];

// --- Решта мок-даних без змін ---

final mockBloodCenters = [
  BloodCenterModel(
    name: "Київський міський центр крові",
    address: "вул. Максима Берлинського, 12",
    workingHours: "Пн-Пт: 08:00 - 16:00",
    phone: "+380 44 440 6533",
    latitude: 50.4725,
    longitude: 30.4485,
  ),
  BloodCenterModel(
    name: "Львівський обласний центр служби крові",
    address: "вул. Пекарська, 65",
    workingHours: "Пн-Пт: 09:00 - 15:00",
    phone: "+380 32 276 2500",
    latitude: 49.8357,
    longitude: 24.0492,
  ),
  BloodCenterModel(
    name: "Одеська обласна станція переливання крові",
    address: "Бісквітний пров., 2/3",
    workingHours: "Пн-Пт: 08:30 - 14:00",
    phone: "+380 48 776 0467",
    latitude: 46.4447,
    longitude: 30.7410,
  ),
];

final mockRewards = [
  RewardModel(
    title: "Безкоштовний аналіз крові",
    description: "Повний біохімічний аналіз",
    cost: 2000,
    icon: Icons.science_outlined,
  ),
  RewardModel(
    title: "Квиток в кіно",
    description: "На будь-який сеанс у мережі",
    cost: 1500,
    icon: CupertinoIcons.ticket_fill,
  ),
  RewardModel(
    title: "Сертифікат у спортзал",
    description: "Місячний абонемент",
    cost: 5000,
    icon: Icons.fitness_center,
  ),
  RewardModel(
    title: "Чашка кави",
    description: "Безкоштовна кава у партнера",
    cost: 500,
    icon: Icons.coffee,
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
