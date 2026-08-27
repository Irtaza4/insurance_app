import 'package:flutter/material.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_animations.dart';

class RewardsScreen extends StatelessWidget {
  final InsuranceState state;

  const RewardsScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Rewards & Benefits',
          style: AppTypography.h1.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Points Hero Card with Terracotta Gradient (Slides down)
            SlideDownFade(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE26145),
                      Color(0xFFC44730),
                      Color(0xFF8E3424),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'PLATINUM REWARDS',
                            style: AppTypography.captionBold.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 26),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '3,450',
                      style: AppTypography.displayLight.copyWith(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Available Reward Points (\$34.50 Value)',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFFD59E), size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '7-Day Safe Driving & Health Streak (+250 bonus pts)',
                              style: AppTypography.captionBold.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Redeem for Insurance Discounts (Slides in from right)
            SlideRightFade(
              delay: const Duration(milliseconds: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Redeem for Discounts',
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildRewardItem(
                    context,
                    title: '\$20 Off Next Auto Premium',
                    subtitle: 'Apply directly towards policy #INS-28491',
                    points: '2,000 pts',
                    icon: Icons.directions_car_rounded,
                    color: const Color(0xFFF6E7E2),
                    iconColor: AppColors.primary,
                  ),
                  _buildRewardItem(
                    context,
                    title: 'Free Dental & Vision Exam',
                    subtitle: '100% cashless voucher at in-network clinics',
                    points: '1,500 pts',
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFF3EBE6),
                    iconColor: AppColors.secondaryBrown,
                  ),
                  _buildRewardItem(
                    context,
                    title: '\$15 Pharmacy & HSA Credit',
                    subtitle: 'Direct digital prescription rebate',
                    points: '1,500 pts',
                    icon: Icons.medication_rounded,
                    color: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Earn More Points (Slides up with fade)
            SlideUpFade(
              delay: const Duration(milliseconds: 280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ways to Earn',
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _buildEarnCard(
                    title: 'Annual Health Checkup Verification',
                    reward: '+500 pts',
                    description: 'Upload your wellness assessment from Harmony General Hospital.',
                    action: 'Upload Report',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report upload portal opened')),
                      );
                    },
                  ),
                  _buildEarnCard(
                    title: 'Safe Driving Telematics Sync',
                    reward: '+150 pts/wk',
                    description: 'Zero hard braking incidents logged for 30 consecutive days.',
                    action: 'View Score (96/100)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Telematics driving score is 96/100 (Safe Driver)')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String points,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              minimumSize: const Size(80, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Redeemed: $title for $points!')),
              );
            },
            child: Text(points, style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnCard({
    required String title,
    required String reward,
    required String description,
    required String action,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 14.5)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  reward,
                  style: AppTypography.captionBold.copyWith(color: AppColors.statusApprovedText, fontSize: 11.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: AppTypography.bodySecondary.copyWith(fontSize: 13)),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Text(
              action,
              style: AppTypography.button.copyWith(color: AppColors.primary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
