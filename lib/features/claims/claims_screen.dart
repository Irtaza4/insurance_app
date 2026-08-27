import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/buttons_and_inputs.dart';
import '../../shared/widgets/claim_timeline_widget.dart';
import 'submit_claim_modal.dart';

class ClaimsScreen extends StatelessWidget {
  final InsuranceState state;

  const ClaimsScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final claims = state.claims;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Your Claims',
          style: AppTypography.h1.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryDark, size: 26),
            onPressed: () => _openSubmitClaimModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: claims.isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active summary banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.neutralBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF6E7E2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pending_actions_rounded, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.activeClaims.length} Active Claim${state.activeClaims.length == 1 ? '' : 's'}',
                                style: AppTypography.h2.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Track live adjuster progress and payout updates',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Claims List
                  ...claims.map((claim) => _buildClaimCard(context, claim)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text('New Claim', style: AppTypography.button.copyWith(color: Colors.white)),
        onPressed: () => _openSubmitClaimModal(context),
      ),
    );
  }

  Widget _buildClaimCard(BuildContext context, Claim claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Claim ID & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Claim #${claim.id}',
                    style: AppTypography.h2.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(claim.status),
              ],
            ),
            const SizedBox(height: 4),

            // Policy Name & Incident Type
            Text(
              claim.policyName,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryBrown,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${claim.incidentType} • Submitted ${claim.submittedDate}',
              style: AppTypography.caption,
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.neutralBorder),
            const SizedBox(height: 16),

            // Progress Timeline
            Text(
              'Claim Progress',
              style: AppTypography.captionBold.copyWith(
                fontSize: 13,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 14),
            ClaimTimelineWidget(steps: claim.timeline),

            const SizedBox(height: 14),
            const Divider(color: AppColors.neutralBorder),
            const SizedBox(height: 14),

            // Description & Estimated Response
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Response', style: AppTypography.caption),
                      const SizedBox(height: 2),
                      Text(
                        claim.estimatedResponse,
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.primary,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Documents', style: AppTypography.caption),
                    const SizedBox(height: 2),
                    Text(
                      '${claim.documents.length} files attached',
                      style: AppTypography.captionBold.copyWith(fontSize: 13.5),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 15),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('View Documents'),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showDocumentsSheet(context, claim),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Contact Adjuster'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Connecting to adjuster for claim #${claim.id}...')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ClaimStatus status) {
    Color bg;
    Color text;

    switch (status) {
      case ClaimStatus.underReview:
        bg = const Color(0xFFF8EFEA);
        text = const Color(0xFFC44730);
        break;
      case ClaimStatus.approved:
        bg = const Color(0xFFEAF5EB);
        text = const Color(0xFF2E6333);
        break;
      case ClaimStatus.completed:
        bg = const Color(0xFFE8EEF5);
        text = const Color(0xFF2C4A6F);
        break;
      case ClaimStatus.submitted:
      case ClaimStatus.documentsReceived:
        bg = const Color(0xFFFBF0E4);
        text = const Color(0xFFB45309);
        break;
      case ClaimStatus.rejected:
        bg = const Color(0xFFFCE8E6);
        text = const Color(0xFFC5221F);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.label,
        style: AppTypography.captionBold.copyWith(
          color: text,
          fontSize: 11.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF3EBE6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 20),
            Text('No active claims', style: AppTypography.h2),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any active claims right now. All your assets and policies are protected.',
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                label: 'Start a claim',
                onPressed: () => _openSubmitClaimModal(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSubmitClaimModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubmitClaimModal(state: state),
    );
  }

  void _showDocumentsSheet(BuildContext context, Claim claim) {
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
              Text('Claim #${claim.id} Documents', style: AppTypography.h2),
              const SizedBox(height: 8),
              Text('Attached evidence and reports for evaluation.', style: AppTypography.bodySecondary),
              const SizedBox(height: 16),
              ...claim.documents.map((doc) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_rounded, color: AppColors.primary),
                    title: Text(doc, style: AppTypography.bodyMedium),
                    trailing: const Icon(Icons.download_rounded, color: AppColors.primaryDark),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading $doc...')),
                      );
                    },
                  )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
