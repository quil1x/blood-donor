import 'package:flutter/material.dart';
import 'package:donor_dashboard/data/models/blood_type_model.dart';


final List<BloodTypeModel> bloodTypes = [
  BloodTypeModel(
    type: 'O+',
    rarity: 'Найпоширеніша',
    percentage: 37,
    description: 'Універсальний донор для позитивних груп',
    color: Colors.red,
  ),
  BloodTypeModel(
    type: 'A+',
    rarity: 'Поширена',
    percentage: 35,
    description: 'Друга за поширеністю група',
    color: Colors.blue,
  ),
  BloodTypeModel(
    type: 'B+',
    rarity: 'Рідкісна',
    percentage: 8,
    description: 'Рідкісна група крові',
    color: Colors.green,
  ),
  BloodTypeModel(
    type: 'AB+',
    rarity: 'Найрідкісніша',
    percentage: 3,
    description: 'Універсальний реципієнт',
    color: Colors.purple,
  ),
  BloodTypeModel(
    type: 'O-',
    rarity: 'Дуже рідкісна',
    percentage: 6,
    description: 'Універсальний донор для всіх',
    color: Colors.orange,
  ),
  BloodTypeModel(
    type: 'A-',
    rarity: 'Рідкісна',
    percentage: 6,
    description: 'Рідкісна негативна група',
    color: Colors.teal,
  ),
  BloodTypeModel(
    type: 'B-',
    rarity: 'Дуже рідкісна',
    percentage: 2,
    description: 'Дуже рідкісна група',
    color: Colors.indigo,
  ),
  BloodTypeModel(
    type: 'AB-',
    rarity: 'Найрідкісніша',
    percentage: 1,
    description: 'Найрідкісніша група крові',
    color: Colors.pink,
  ),
];


final List<BloodCenterStats> bloodCentersStats = [
  BloodCenterStats(
    name: 'Київський центр крові',
    donations: 1250,
    capacity: 2000,
    rating: 4.8,
    address: 'вул. Хрещатик, 22',
  ),
  BloodCenterStats(
    name: 'Львівський центр крові',
    donations: 890,
    capacity: 1500,
    rating: 4.6,
    address: 'вул. Свободи, 15',
  ),
  BloodCenterStats(
    name: 'Харківський центр крові',
    donations: 750,
    capacity: 1200,
    rating: 4.7,
    address: 'вул. Сумська, 1',
  ),
  BloodCenterStats(
    name: 'Дніпровський центр крові',
    donations: 650,
    capacity: 1000,
    rating: 4.5,
    address: 'вул. Набережна, 8',
  ),
  BloodCenterStats(
    name: 'Одеський центр крові',
    donations: 580,
    capacity: 900,
    rating: 4.4,
    address: 'вул. Дерибасівська, 3',
  ),
];


final List<BonusTracker> bonusTrackers = [
  BonusTracker(
    title: 'Перша донація',
    currentPoints: 100,
    maxPoints: 100,
    description: 'Зробіть свою першу донацію',
    isCompleted: true,
  ),
  BonusTracker(
    title: 'Місячний донор',
    currentPoints: 75,
    maxPoints: 100,
    description: 'Зробіть 4 донації за місяць',
    isCompleted: false,
  ),
  BonusTracker(
    title: 'Річний донор',
    currentPoints: 45,
    maxPoints: 100,
    description: 'Зробіть 12 донацій за рік',
    isCompleted: false,
  ),
  BonusTracker(
    title: 'Вірний донор',
    currentPoints: 20,
    maxPoints: 100,
    description: 'Зробіть 50 донацій за все',
    isCompleted: false,
  ),
  BonusTracker(
    title: 'Екстрений донор',
    currentPoints: 0,
    maxPoints: 100,
    description: 'Відгукніться на екстрений виклик',
    isCompleted: false,
  ),
];
