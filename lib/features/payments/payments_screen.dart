import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_animations.dart';
import '../../shared/widgets/buttons_and_inputs.dart';

class PaymentsScreen extends StatelessWidget {
  final InsuranceState state;

  const PaymentsScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Payments & Billing',
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
            // 1. Next Payment Hero Card (Slides down)
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
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next payment', style: AppTypography.bodySecondary),
                    const SizedBox(height: 6),
                    Text(
                      '\$${state.totalUpcomingPremiums.toStringAsFixed(2)}',
                      style: AppTypography.display.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 15, color: AppColors.textGray),
                        const SizedBox(width: 5),
                        Text('Due 12 Sep 2026', style: AppTypography.captionBold.copyWith(color: AppColors.secondaryBrown)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Pay now',
                            height: 48,
                            onPressed: state.upcomingPayments.isNotEmpty
                                ? () => _showPayNowModal(context, state.upcomingPayments.first)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Manage auto-pay',
                            height: 48,
                            onPressed: () => _showAutoPayModal(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // 2. Upcoming Premiums Breakdown (Slides in from right)
            SlideRightFade(
              delay: const Duration(milliseconds: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Invoices (${state.upcomingPayments.length})',
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ...state.upcomingPayments.map((item) => _buildInvoiceTile(context, item)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 3. Payment History (Slides up with fade)
            SlideUpFade(
              delay: const Duration(milliseconds: 260),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment History',
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.neutralBorder),
                    ),
                    child: Column(
                      children: state.paymentHistory.map((item) {
                        final isLast = state.paymentHistory.indexOf(item) == state.paymentHistory.length - 1;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F3EF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item.category.icon, color: AppColors.secondaryBrown, size: 20),
                              ),
                              title: Text(item.title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 14.5)),
                              subtitle: Text('Paid on ${item.paidDate ?? item.dueDate} • #${item.policyNumber}', style: AppTypography.caption),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${item.amount.toStringAsFixed(2)}',
                                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 14.5),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.statusApprovedBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Paid',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.statusApprovedText,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Downloading receipt for ${item.title}...')),
                                );
                              },
                            ),
                            if (!isLast) const Divider(height: 1, color: AppColors.neutralBorder),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceTile(BuildContext context, PaymentItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EFEA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.category.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text('Due ${item.dueDate} • #${item.policyNumber}', style: AppTypography.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.amount.toStringAsFixed(2)}',
                style: AppTypography.h3.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () => _showPayNowModal(context, item),
                child: Text(
                  'Pay now',
                  style: AppTypography.button.copyWith(color: AppColors.primary, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPayNowModal(BuildContext context, PaymentItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Confirm Premium Payment', style: AppTypography.h2),
              const SizedBox(height: 6),
              Text(item.title, style: AppTypography.captionBold),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount Due', style: AppTypography.bodyMedium),
                    Text('\$${item.amount.toStringAsFixed(2)}', style: AppTypography.h2.copyWith(color: AppColors.primaryDark)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Payment Method:', style: AppTypography.captionBold),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.credit_card_rounded, color: AppColors.primaryDark),
                title: const Text('Visa ending in 4821'),
                subtitle: const Text('Expires 08/28'),
                trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Pay \$${item.amount.toStringAsFixed(2)}',
                onPressed: () {
                  state.payUpcomingPremium(item.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment of \$${item.amount.toStringAsFixed(2)} successful!')),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showAutoPayModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Auto-Pay Settings', style: AppTypography.h2),
              const SizedBox(height: 6),
              Text('Automatic monthly renewal deduction for active policies.', style: AppTypography.bodySecondary),
              const SizedBox(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Auto-Pay'),
                subtitle: const Text('Deduct premiums on due date via primary payment method'),
                value: true,
                activeTrackColor: AppColors.primary,
                onChanged: (v) {},
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Save Preferences',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
