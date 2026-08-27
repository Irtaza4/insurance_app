import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/buttons_and_inputs.dart';
import '../claims/submit_claim_modal.dart';

class PolicyDetailScreen extends StatelessWidget {
  final Policy policy;
  final InsuranceState state;

  const PolicyDetailScreen({
    super.key,
    required this.policy,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${policy.category.displayName} Insurance',
          style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.statusActiveBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              policy.status,
              style: AppTypography.captionBold.copyWith(
                color: AppColors.statusActiveText,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.neutralBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6E7E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(policy.category.icon, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              policy.name,
                              style: AppTypography.h2.copyWith(fontSize: 19),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Policy #${policy.policyNumber}',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: AppColors.neutralBorder),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _overviewStat('Total Coverage', '\$${policy.coverageAmount.toStringAsFixed(0)}'),
                      _overviewStat('Monthly Premium', '\$${policy.premiumMonthly.toStringAsFixed(2)}'),
                      _overviewStat('Deductible', '\$${policy.deductible.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.event_repeat_rounded, size: 16, color: AppColors.textGray),
                      const SizedBox(width: 6),
                      Text(
                        'Renews on ${policy.renewalDate}',
                        style: AppTypography.caption.copyWith(color: AppColors.secondaryBrown, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Coverage Limits Section
            Text('Coverage Breakdown', style: AppTypography.h2.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.neutralBorder),
              ),
              child: Column(
                children: policy.coverages.map((item) {
                  final isLast = policy.coverages.indexOf(item) == policy.coverages.length - 1;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.title, style: AppTypography.bodyMedium),
                          Text(
                            '\$${item.amount.toStringAsFixed(0)}',
                            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      if (!isLast) const Divider(height: 24),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Documents Section
            Text('Policy Documents', style: AppTypography.h2.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.neutralBorder),
              ),
              child: Column(
                children: policy.documents.map((doc) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F2EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 22),
                    ),
                    title: Text(doc.title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('${doc.format} • ${doc.size} • ${doc.date}', style: AppTypography.caption),
                    trailing: IconButton(
                      icon: const Icon(Icons.download_rounded, color: AppColors.primaryDark),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${doc.title}...')),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 28),

            // Action: Start Claim for this policy
            PrimaryButton(
              label: 'File a Claim for this Policy',
              leadingIcon: Icons.add_circle_outline_rounded,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SubmitClaimModal(state: state),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
