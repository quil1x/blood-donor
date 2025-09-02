import 'package:donor_dashboard/data/models/blood_center_model.dart';
import 'package:donor_dashboard/data/models/donation_model.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:donor_dashboard/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var mockUser = UserModel(
  name: "Олена Петренко",
  rank: "Почесний донор",
  avatarUrl: "https://i.pravatar.cc/150?u=a042581f4e29026704d",
  totalDonations: 12,
  livesSaved: 36,
  totalPoints: 4500,
);

var mockQuests = [
  QuestModel(
    title: "Перша донація",
    description: "Здайте кров уперше",
    rewardPoints: 500,
    progress: 1.0,
    icon: CupertinoIcons.drop_fill,
  ),
  QuestModel(
    title: "Запроси друга",
    description: "Запросіть друга стати донором",
    rewardPoints: 300,
    progress: 0.5,
    icon: CupertinoIcons.person_2_fill,
  ),
  QuestModel(
    title: "Донор-спринтер",
    description: "Здайте кров 3 рази за рік",
    rewardPoints: 1000,
    progress: 0.66,
    icon: CupertinoIcons.flame_fill,
  ),
];

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
  DonationModel(date: DateTime(2025, 5, 20), location: "Київський міський центр крові"),
  DonationModel(date: DateTime(2025, 2, 15), location: "Київський міський центр крові"),
  DonationModel(date: DateTime(2024, 11, 10), location: "Львівський обласний центр"),
];

void completeQuestAndUpdatePoints(QuestModel quest) {
  if (quest.progress < 1.0) {
    quest.progress = 1.0;
    mockUser = UserModel(
      name: mockUser.name,
      rank: mockUser.rank,
      avatarUrl: mockUser.avatarUrl,
      totalDonations: mockUser.totalDonations,
      livesSaved: mockUser.livesSaved,
      totalPoints: mockUser.totalPoints + quest.rewardPoints,
    );
  }
}