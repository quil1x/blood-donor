import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BloodCentersScreen extends StatelessWidget {
  final VoidCallback onUpdate;
  const BloodCentersScreen({super.key, required this.onUpdate});

  void _completeVisitQuest(BuildContext context) {
    final authService = StaticAuthService();
    final currentUser = authService.currentUser;
    const questId = "visit_blood_center";

    if (currentUser != null &&
        !currentUser.completedQuests.containsKey(questId)) {
      currentUser.completedQuests[questId] = DateTime.now();
      currentUser.totalPoints += 150;
      authService
          .updateUserProfile(currentUser); // Оновлюємо через LocalAuthService
      onUpdate();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Квест "Розвідник" виконано! +150 XP'),
          backgroundColor: AppColors.greenAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ви вже виконували цей квест.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = mockBloodCenters.map((center) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(center.latitude, center.longitude),
        child: Icon(Icons.location_pin,
            color: Theme.of(context).primaryColor, size: 40.0),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Центри крові')),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(49.8397, 24.0297), initialZoom: 6.0),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.donor_dashboard',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: mockBloodCenters.length,
              itemBuilder: (context, index) {
                final center = mockBloodCenters[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(center.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        InfoRow(
                            icon: CupertinoIcons.placemark_fill,
                            text: center.address),
                        const SizedBox(height: 4),
                        InfoRow(
                            icon: CupertinoIcons.clock_fill,
                            text: center.workingHours),
                        const SizedBox(height: 4),
                        InfoRow(
                            icon: CupertinoIcons.phone_fill,
                            text: center.phone),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _completeVisitQuest(context),
                            icon: const Icon(CupertinoIcons.calendar_badge_plus,
                                size: 20),
                            label: const Text('Запланувати візит'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
