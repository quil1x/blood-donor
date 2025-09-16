import 'package:donor_dashboard/core/widgets/reward_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/material.dart';

class RewardsStoreScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const RewardsStoreScreen({super.key, required this.onUpdate});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen>
    with TickerProviderStateMixin {
  final StaticAuthService _authService = StaticAuthService();
  final TextEditingController _searchController = TextEditingController();
  
  List<RewardModel> _filteredRewards = [];
  RewardCategory? _selectedCategory;
  String _sortBy = 'name';
  bool _showOnlyAffordable = false;
  bool _isGridView = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _filteredRewards = mockRewards;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterRewards() {
    setState(() {
      _filteredRewards = mockRewards.where((reward) {
        final searchText = _searchController.text.toLowerCase();
        final matchesSearch = searchText.isEmpty ||
            reward.title.toLowerCase().contains(searchText) ||
            reward.description.toLowerCase().contains(searchText) ||
            reward.partnerName?.toLowerCase().contains(searchText) == true;

        final matchesCategory = _selectedCategory == null ||
            reward.category == _selectedCategory;
        final currentUser = _authService.currentUser;
        final matchesAffordability = !_showOnlyAffordable ||
            (currentUser != null && currentUser.totalPoints >= reward.cost);

        return matchesSearch && matchesCategory && matchesAffordability;
      }).toList();

      _filteredRewards.sort((a, b) {
        switch (_sortBy) {
          case 'price_low':
            return a.cost.compareTo(b.cost);
          case 'price_high':
            return b.cost.compareTo(a.cost);
          case 'rating':
            return b.rating.compareTo(a.rating);
          case 'popular':
            if (a.isPopular && !b.isPopular) return -1;
            if (!a.isPopular && b.isPopular) return 1;
            return 0;
          default:
            return a.title.compareTo(b.title);
        }
      });
    });
  }

  Future<void> _handlePurchase(int cost, AppUser currentUser) async {
    if (currentUser.totalPoints >= cost) {
      currentUser.totalPoints -= cost;
      final success = await _authService.updateUserProfile(currentUser);
      if (success) {
        widget.onUpdate();
        _filterRewards();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Покупка успішна!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Помилка оновлення профілю'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Недостатньо балів!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: ListenableBuilder(
        listenable: _authService,
        builder: (context, child) {
          final currentUser = _authService.currentUser;
          if (currentUser == null) {
            return const Center(child: Text("Помилка завантаження даних."));
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.blueAccent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Магазин бонусів',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.blueAccent,
                            AppColors.blueAccent.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.stars,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${currentUser.totalPoints} балів',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => _filterRewards(),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Пошук нагород...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterRewards();
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: AppColors.lightCard,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCategoryChip('Всі', null),
                                    const SizedBox(width: 8),
                                    ...RewardCategory.values.map(
                                      (category) => Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: _buildCategoryChip(
                                          _getCategoryName(category),
                                          category,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isGridView = !_isGridView;
                                });
                              },
                              icon: Icon(
                                _isGridView ? Icons.list : Icons.grid_view,
                                color: AppColors.blueAccent,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                setState(() {
                                  _sortBy = value;
                                  _filterRewards();
                                });
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'name',
                                  child: Text('За назвою', style: TextStyle(color: Colors.black)),
                                ),
                                const PopupMenuItem(
                                  value: 'price_low',
                                  child: Text('Ціна: зростання', style: TextStyle(color: Colors.black)),
                                ),
                                const PopupMenuItem(
                                  value: 'price_high',
                                  child: Text('Ціна: спадання', style: TextStyle(color: Colors.black)),
                                ),
                                const PopupMenuItem(
                                  value: 'rating',
                                  child: Text('За рейтингом', style: TextStyle(color: Colors.black)),
                                ),
                                const PopupMenuItem(
                                  value: 'popular',
                                  child: Text('Популярні', style: TextStyle(color: Colors.black)),
                                ),
                              ],
                              child: Icon(
                                Icons.sort,
                                color: AppColors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: _showOnlyAffordable,
                              onChanged: (value) {
                                setState(() {
                                  _showOnlyAffordable = value ?? false;
                                  _filterRewards();
                                });
                              },
                              activeColor: AppColors.blueAccent,
                            ),
                            const Text(
                              'Тільки доступні',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                _isGridView
                    ? SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _getCrossAxisCount(context),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: _getChildAspectRatio(context),
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final reward = _filteredRewards[index];
                              return RewardCard(
                                reward: reward,
                                userPoints: currentUser.totalPoints,
                                onPurchase: () => _handlePurchase(reward.cost, currentUser),
                              );
                            },
                            childCount: _filteredRewards.length,
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reward = _filteredRewards[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: _buildListCard(reward, currentUser),
                            );
                          },
                          childCount: _filteredRewards.length,
                        ),
                      ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Показано ${_filteredRewards.length} з ${mockRewards.length} нагород',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, RewardCategory? category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.blueAccent : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
          _filterRewards();
        });
      },
      selectedColor: AppColors.blueAccent.withOpacity(0.2),
      checkmarkColor: AppColors.blueAccent,
      backgroundColor: AppColors.lightCard,
      side: BorderSide(
        color: isSelected ? AppColors.blueAccent : AppColors.lightBorder,
      ),
    );
  }

  Widget _buildListCard(RewardModel reward, AppUser currentUser) {
    final bool canAfford = currentUser.totalPoints >= reward.cost;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: reward.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                reward.icon,
                size: 32,
                color: reward.categoryColor,
              ),
            ),
            const SizedBox(width: 12            ),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (reward.rating > 0) ...[
                        ...List.generate(5, (index) {
                          return Icon(
                            index < reward.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        '${reward.cost} балів',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: canAfford
                              ? AppColors.blueAccent
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: canAfford
                    ? AppColors.blueAccent
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: canAfford ? () => _handlePurchase(reward.cost, currentUser) : null,
                icon: Icon(
                  canAfford ? Icons.shopping_cart : Icons.lock,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 0.65;
    if (width < 800) return 0.7;
    return 0.75;
  }

  String _getCategoryName(RewardCategory category) {
    switch (category) {
      case RewardCategory.health:
        return 'Здоров\'я';
      case RewardCategory.entertainment:
        return 'Розваги';
      case RewardCategory.lifestyle:
        return 'Стиль життя';
      case RewardCategory.food:
        return 'Їжа';
      case RewardCategory.education:
        return 'Освіта';
      case RewardCategory.special:
        return 'Спеціальні';
    }
  }
}
