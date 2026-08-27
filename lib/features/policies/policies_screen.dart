import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_animations.dart';
import 'policy_detail_screen.dart';

class PoliciesScreen extends StatelessWidget {
  final InsuranceState state;

  const PoliciesScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = state.filteredPolicies;
    final totalCoverage = state.policies.fold(0.0, (sum, p) => sum + p.coverageAmount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Your Policies',
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
            // Total Coverage Card (Slides down)
            SlideDownFade(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.neutralBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Coverage', style: AppTypography.bodySecondary),
                    const SizedBox(height: 6),
                    Text(
                      '\$${totalCoverage.toStringAsFixed(0)}',
                      style: AppTypography.display.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.statusActiveBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Active',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.statusActiveText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.policies.length} policies protected',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.secondaryBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filter Tabs (Slides in from right)
            SlideRightFade(
              delay: const Duration(milliseconds: 100),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _filterChip(null, 'All (${state.policies.length})'),
                    _filterChip(PolicyCategory.auto, 'Auto'),
                    _filterChip(PolicyCategory.health, 'Health'),
                    _filterChip(PolicyCategory.home, 'Home'),
                    _filterChip(PolicyCategory.life, 'Life'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Policy Cards List (Staggered slide in from right)
            ...filtered.asMap().entries.map((entry) {
              final index = entry.key;
              final policy = entry.value;
              return SlideRightFade(
                delay: Duration(milliseconds: 120 + index * 60),
                child: _buildPolicyCard(context, policy),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(PolicyCategory? category, String label) {
    final isSelected = state.selectedPolicyCategoryFilter == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => state.filterPoliciesByCategory(category),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.primaryDark : AppColors.neutralBorder,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.captionBold.copyWith(
              color: isSelected ? Colors.white : AppColors.primaryDark,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(BuildContext context, Policy policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PolicyDetailScreen(policy: policy, state: state),
              ),
            );
          },
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Category icon, name, status badge
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F2EE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        policy.category.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${policy.category.displayName} Insurance',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.secondaryBrown,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            policy.name,
                            style: AppTypography.h3.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusActiveBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        policy.status,
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.statusActiveText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: AppColors.neutralBorder),
                const SizedBox(height: 14),

                // Policy Number, Coverage, Renewal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Policy Number', style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Text(
                          policy.policyNumber,
                          style: AppTypography.captionBold.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coverage', style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Text(
                          '\$${policy.coverageAmount.toStringAsFixed(0)}',
                          style: AppTypography.captionBold.copyWith(
                            fontSize: 14,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Renewal', style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Text(
                          policy.renewalDate,
                          style: AppTypography.captionBold.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
