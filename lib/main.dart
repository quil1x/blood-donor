import 'package:donor_dashboard/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk_UA', null);

  runApp(const DonorDashboardApp());
}