import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/services/dashboard_service.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/data/blood_data.dart';
import 'package:donor_dashboard/data/models/blood_type_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  final StaticAuthService _authService = StaticAuthService();

  @override
  void initState() {
    super.initState();
    _dashboardService.syncWithCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isTablet = MediaQuery.of(context).size.width < 1024;

    return ListenableBuilder(
      listenable: Listenable.merge([_dashboardService, _authService]),
      builder: (context, child) {
        _dashboardService.syncWithCurrentUser();
        final displayUser = _dashboardService.getCurrentData();
        
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(displayUser, isMobile),
                SizedBox(height: isMobile ? 20 : 32),

                _buildStatsGrid(displayUser, isMobile, isTablet),
                SizedBox(height: isMobile ? 20 : 32),

                if (isMobile) ...[
                  _buildBloodTypesSection(isMobile),
                  SizedBox(height: 16),
                  _buildCentersSection(isMobile),
                  SizedBox(height: 16),
                  _buildBonusTrackerSection(isMobile),
                  SizedBox(height: 16),
                  _buildChartsSection(displayUser, isMobile),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildBloodTypesSection(isMobile),
                            SizedBox(height: 20),
                            _buildCentersSection(isMobile),
                            SizedBox(height: 20),
                            _buildBonusTrackerSection(isMobile),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: _buildChartsSection(displayUser, isMobile),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: isMobile ? 20 : 32),

                _buildInfoSection(displayUser, isMobile),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildHeader(AppUser currentUser, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Привіт, ${currentUser.name}!',
          style: TextStyle(
            fontSize: isMobile ? 18 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Ваші донації допомагають врятувати життя!',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: AppColors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(AppUser currentUser, bool isMobile, bool isTablet) {
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    final childAspectRatio = isMobile ? 1.2 : 1.5;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          'Донації',
          '${currentUser.totalDonations}',
          '+${currentUser.totalDonations > 0 ? currentUser.totalDonations ~/ 2 : 0} цього місяця',
          Icons.favorite,
          AppColors.blueAccent,
          isMobile,
        ),
        _buildStatCard(
          'Збережено життів',
          '${currentUser.livesSaved}',
          '+${currentUser.livesSaved > 0 ? currentUser.livesSaved ~/ 2 : 0} цього місяця',
          Icons.favorite_border,
          Colors.red,
          isMobile,
        ),
        _buildStatCard(
          'Доступно донацій',
          '${3 - (currentUser.totalDonations % 3)}',
          'до наступної',
          Icons.schedule,
          Colors.orange,
          isMobile,
        ),
        _buildStatCard(
          'Бали',
          '${currentUser.totalPoints}',
          '+${currentUser.totalPoints > 100 ? currentUser.totalPoints - 100 : 0} цього місяця',
          Icons.star,
          Colors.amber,
          isMobile,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String change, IconData icon, Color color, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 6 : 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: isMobile ? 16 : 24),
                ),
                if (!isMobile)
                  Flexible(
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: isMobile ? 2 : 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 14,
                      color: AppColors.lightTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isMobile) ...[
                    SizedBox(height: 2),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypesSection(bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bloodtype, color: AppColors.blueAccent, size: isMobile ? 20 : 24),
                SizedBox(width: 8),
                Text(
                  'Групи крові та рідкість',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            ...bloodTypes.take(4).map((bloodType) => _buildBloodTypeItem(bloodType, isMobile)),
            if (isMobile) ...[
              SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: Text('Показати всі', style: TextStyle(color: AppColors.blueAccent)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypeItem(BloodTypeModel bloodType, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
      child: Row(
        children: [
          Container(
            width: isMobile ? 30 : 40,
            height: isMobile ? 20 : 24,
            decoration: BoxDecoration(
              color: bloodType.color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                bloodType.type,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bloodType.rarity,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  '${bloodType.percentage}% населення',
                  style: TextStyle(
                    fontSize: isMobile ? 9 : 10,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: isMobile ? 30 : 40,
            height: 4,
            decoration: BoxDecoration(
              color: bloodType.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentersSection(bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.blueAccent, size: isMobile ? 20 : 24),
                SizedBox(width: 8),
                Text(
                  'Топ центри донорства',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            ...bloodCentersStats.take(3).map((center) => _buildCenterItem(center, isMobile)),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterItem(BloodCenterStats center, bool isMobile) {
    final percentage = (center.donations / center.capacity * 100).round();
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.name,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  center.address,
                  style: TextStyle(
                    fontSize: isMobile ? 9 : 10,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: isMobile ? 12 : 14),
                    SizedBox(width: 4),
                    Text(
                      '${center.rating}',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${center.donations}/${center.capacity}',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: isMobile ? 40 : 60,
            height: 4,
            decoration: BoxDecoration(
              color: percentage > 80 ? Colors.green : percentage > 50 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusTrackerSection(bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.track_changes, color: AppColors.blueAccent, size: isMobile ? 20 : 24),
                SizedBox(width: 8),
                Text(
                  'Трекер бонусів',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            ...bonusTrackers.take(3).map((bonus) => _buildBonusItem(bonus, isMobile)),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusItem(BonusTracker bonus, bool isMobile) {
    final progress = bonus.currentPoints / bonus.maxPoints;
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bonus.title,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${bonus.currentPoints}/${bonus.maxPoints}',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(
              bonus.isCompleted ? Colors.green : AppColors.blueAccent,
            ),
          ),
          SizedBox(height: 4),
          Text(
            bonus.description,
            style: TextStyle(
              fontSize: isMobile ? 9 : 10,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(AppUser currentUser, bool isMobile) {
    return Column(
      children: [
        _buildDonationChart(currentUser, isMobile),
        SizedBox(height: 16),
        _buildMonthlyChart(currentUser, isMobile),
        SizedBox(height: 16),
        _buildCentersChart(currentUser, isMobile),
      ],
    );
  }

  Widget _buildDonationChart(AppUser currentUser, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Статистика донацій',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              height: isMobile ? 150 : 200,
              width: double.infinity,
              child: _buildSimpleBarChart(currentUser.totalDonations, isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(AppUser currentUser, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Донації по місяцях',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              height: isMobile ? 150 : 200,
              width: double.infinity,
              child: _buildSimpleBarChart(currentUser.totalDonations, isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentersChart(AppUser currentUser, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Центри донорства',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              height: isMobile ? 150 : 200,
              width: double.infinity,
              child: _buildSimpleBarChart(currentUser.totalDonations, isMobile),
            ),
            if (isMobile) ...[
              SizedBox(height: 12),
              _buildCentersLegend(currentUser),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart(int totalDonations, bool isMobile) {
    if (totalDonations == 0) {
      return Center(
        child: Text(
          'Немає даних для відображення',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      );
    }

    final data = _generateSimpleData(totalDonations);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.map((item) => Padding(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${item.value.toInt()}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 4 : 6),
            Container(
              height: isMobile ? 8 : 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.lightGrey,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: item.percentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  List<SimpleData> _generateSimpleData(int totalDonations) {
    if (totalDonations == 0) return [];
    
    return [
      SimpleData(
        label: 'Київ',
        value: (totalDonations * 0.4).toDouble(),
        percentage: 0.4,
        color: AppColors.blueAccent,
      ),
      SimpleData(
        label: 'Львів',
        value: (totalDonations * 0.3).toDouble(),
        percentage: 0.3,
        color: Colors.green,
      ),
      SimpleData(
        label: 'Харків',
        value: (totalDonations * 0.2).toDouble(),
        percentage: 0.2,
        color: Colors.orange,
      ),
      SimpleData(
        label: 'Інші',
        value: (totalDonations * 0.1).toDouble(),
        percentage: 0.1,
        color: Colors.grey,
      ),
    ];
  }

  Widget _buildCentersLegend(AppUser currentUser) {
    final data = _generateCenterDistribution(currentUser.totalDonations);
    return Column(
      children: data.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item.label}: ${item.value.toInt()}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildInfoSection(AppUser currentUser, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.blueAccent,
                  size: isMobile ? 20 : 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Ваша статистика донорства',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              'Ви зробили ${currentUser.totalDonations} донацій та врятували ${currentUser.livesSaved} життів!',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Кожна донація може врятувати до 3 життів. Дякуємо за ваш внесок!',
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: AppColors.lightTextSecondary,
              ),
            ),
            if (currentUser.totalDonations == 0) ...[
              SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.blueAccent, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Почніть свою подорож донора сьогодні!',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  List<DonutData> _generateCenterDistribution(int totalDonations) {
    if (totalDonations == 0) {
      return const [
        DonutData(label: 'Київ', value: 0, color: AppColors.blueAccent),
        DonutData(label: 'Львів', value: 0, color: Colors.green),
        DonutData(label: 'Харків', value: 0, color: Colors.orange),
        DonutData(label: 'Інші', value: 0, color: Colors.grey),
      ];
    }
    
    int kyiv = (totalDonations * 0.45).round();
    int lviv = (totalDonations * 0.25).round();
    int kharkiv = (totalDonations * 0.20).round();
    int others = totalDonations - kyiv - lviv - kharkiv;
    
    return [
      DonutData(label: 'Київ', value: kyiv.toDouble(), color: AppColors.blueAccent),
      DonutData(label: 'Львів', value: lviv.toDouble(), color: Colors.green),
      DonutData(label: 'Харків', value: kharkiv.toDouble(), color: Colors.orange),
      DonutData(label: 'Інші', value: others.toDouble(), color: Colors.grey),
    ];
  }
}

class BarData {
  final String label;
  final double value;
  final Color color;

  const BarData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class DonutData {
  final String label;
  final double value;
  final Color color;

  const DonutData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class SimpleData {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  const SimpleData({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}
