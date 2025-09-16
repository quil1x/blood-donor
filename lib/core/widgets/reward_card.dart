import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class RewardCard extends StatefulWidget {
  final RewardModel reward;
  final int userPoints;
  final VoidCallback onPurchase;

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onPurchase,
  });

  @override
  State<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canAfford = widget.userPoints >= widget.reward.cost;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            onTap: canAfford ? widget.onPurchase : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.lightCard,
                border: Border.all(
                  color: _isPressed 
                      ? AppColors.blueAccent.withOpacity(0.3)
                      : AppColors.lightBorder,
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: _isPressed ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.reward.categoryColor.withOpacity(0.1),
                                widget.reward.categoryColor.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 12 : 16),
                            decoration: BoxDecoration(
                              color: widget.reward.categoryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.reward.icon,
                              size: MediaQuery.of(context).size.width < 600 ? 24 : 32,
                              color: widget.reward.categoryColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Row(
                            children: [
                              if (widget.reward.isNew)
                                _buildBadge('Новинка', Colors.green),
                              if (widget.reward.isPopular)
                                _buildBadge('Популярне', Colors.orange),
                            ],
                          ),
                        ),
                        if (widget.reward.discountPercentage > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: _buildDiscountBadge(),
                          ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width < 600 ? 6 : 8,
                              vertical: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.reward.categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.reward.categoryName,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 600 ? 8 : 10,
                                fontWeight: FontWeight.w600,
                                color: widget.reward.categoryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width < 600 ? 4 : 8),
                          
                          Text(
                            widget.reward.title,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width < 600 ? 2 : 4),
                          
                          Text(
                            widget.reward.description,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600 ? 10 : 12,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width < 600 ? 4 : 8),
                          
                          if (widget.reward.rating > 0)
                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return Icon(
                                    index < widget.reward.rating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: MediaQuery.of(context).size.width < 600 ? 10 : 12,
                                    color: Colors.amber,
                                  );
                                }),
                                SizedBox(width: MediaQuery.of(context).size.width < 600 ? 2 : 4),
                                Text(
                                  '${widget.reward.rating} (${widget.reward.reviewCount})',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width < 600 ? 8 : 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          
                          const Spacer(),
                          
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.reward.originalCost != null)
                                      Text(
                                        '${widget.reward.originalCost} балів',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width < 600 ? 8 : 10,
                                          color: Colors.grey[500],
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    Text(
                                      '${widget.reward.cost} балів',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: canAfford
                                            ? AppColors.blueAccent
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: canAfford
                                      ? AppColors.blueAccent
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: canAfford ? widget.onPurchase : null,
                                  icon: Icon(
                                    canAfford ? Icons.shopping_cart : Icons.lock,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width < 600 ? 14 : 16,
                                  ),
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 6 : 8),
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width < 600 ? 28 : 32,
                                    minHeight: MediaQuery.of(context).size.width < 600 ? 28 : 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, Color color) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 6, 
        vertical: isMobile ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 6 : 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDiscountBadge() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 6, 
        vertical: isMobile ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-${widget.reward.discountPercentage.round()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 6 : 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
