import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class ClaimTimelineWidget extends StatelessWidget {
  final List<ClaimStep> steps;

  const ClaimTimelineWidget({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator column with line
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    _buildStepNode(step),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: step.isCompleted
                              ? AppColors.primary
                              : const Color(0xFFE5E2DE),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Content column
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              step.title,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: step.isCurrent ? FontWeight.w700 : FontWeight.w600,
                                color: step.isCompleted || step.isCurrent
                                    ? AppColors.primaryDark
                                    : AppColors.textGray,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            step.date,
                            style: AppTypography.caption.copyWith(
                              color: step.isCurrent
                                  ? AppColors.primary
                                  : AppColors.textGray,
                              fontWeight: step.isCurrent ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (step.description != null && step.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.description!,
                          style: AppTypography.caption.copyWith(
                            color: step.isCurrent
                                ? AppColors.secondaryBrown
                                : AppColors.textGray,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepNode(ClaimStep step) {
    if (step.isCurrent) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    if (step.isCompleted) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 13,
          color: Colors.white,
        ),
      );
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFEB),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6D1CC), width: 1.5),
      ),
    );
  }
}
