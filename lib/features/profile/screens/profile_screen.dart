import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = mockUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Мій профіль',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildProfileHeader(context, user: user),
          const SizedBox(height: 24),

          _buildStatsCard(context, user: user),
          const SizedBox(height: 24),

          Text('Історія донацій', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildDonationHistory(context),
          const SizedBox(height: 24),

          Text('Дії', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildActionsMenu(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, {required UserModel user}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: theme.textTheme.displayLarge?.copyWith(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          user.rank,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, {required UserModel user}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(value: user.totalDonations.toString(), label: 'Донацій'),
            _StatItem(value: user.livesSaved.toString(), label: 'Життів'),
            _StatItem(value: user.totalPoints.toString(), label: 'Балів'),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationHistory(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'uk_UA');
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mockDonationHistory.length,
        itemBuilder: (context, index) {
          final donation = mockDonationHistory[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              foregroundColor: Theme.of(context).primaryColor,
              child: const Icon(CupertinoIcons.drop, size: 20),
            ),
            title: Text(donation.location, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(
              formatter.format(donation.date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.gear_alt),
            title: const Text('Налаштування'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(CupertinoIcons.gift),
            title: const Text('Мої бонуси'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade400),
            title: Text('Вийти', style: TextStyle(color: Colors.red.shade400)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}