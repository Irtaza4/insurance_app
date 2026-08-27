import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_animations.dart';
import '../../shared/widgets/digital_insurance_card.dart';
import '../../shared/widgets/hero_gradient_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/service_icon_button.dart';

class HomeScreen extends StatelessWidget {
  final InsuranceState state;
  final VoidCallback onNavigateToClaims;
  final VoidCallback onNavigateToHospitals;
  final VoidCallback onNavigateToPayments;
  final VoidCallback onNavigateToTeleconsult;
  final Function(Policy) onSelectPolicy;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateToClaims,
    required this.onNavigateToHospitals,
    required this.onNavigateToPayments,
    required this.onNavigateToTeleconsult,
    required this.onSelectPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Hero Mesh Gradient Card (Slides down from above)
              SlideDownFade(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: HeroGradientCard(
                    greeting: state.userGreeting,
                    userName: state.userName,
                    activeClaimsCount: state.activeClaims.length,
                    upcomingPremiumsCount: state.upcomingPayments.where((p) => !p.isPaid).length,
                    dueDays: 27,
                    totalPremiumAmount: state.totalUpcomingPremiums,
                    onClaimsTap: onNavigateToClaims,
                    onViewPremiumTap: onNavigateToPayments,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Services Section (Slides in from right)
              SlideRightFade(
                delay: const Duration(milliseconds: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Services'),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1
                          Row(
                            children: [
                              ServiceIconButton(
                                icon: Icons.receipt_long_rounded,
                                label: 'Payment',
                                onTap: onNavigateToPayments,
                              ),
                              const SizedBox(width: 10),
                              ServiceIconButton(
                                icon: Icons.file_download_outlined,
                                label: 'Statement Download',
                                onTap: () => _showDownloadStatementModal(context),
                              ),
                              const SizedBox(width: 10),
                              ServiceIconButton(
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'Top up',
                                onTap: () => _showTopUpModal(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row 2
                          Row(
                            children: [
                              ServiceIconButton(
                                icon: Icons.near_me_rounded,
                                label: 'Hospitals',
                                onTap: onNavigateToHospitals,
                              ),
                              const SizedBox(width: 10),
                              ServiceIconButton(
                                icon: Icons.phone_in_talk_rounded,
                                label: 'Teleconsult',
                                onTap: onNavigateToTeleconsult,
                              ),
                              const SizedBox(width: 10),
                              ServiceIconButton(
                                icon: Icons.chat_bubble_rounded,
                                label: 'Chat with',
                                onTap: () => _showConciergeChatModal(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Events Section (Slides in from right)
              SlideRightFade(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Events'),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.events.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final event = state.events[index];
                          return _buildEventCard(context, event);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. e-Cards Section (Slides in from right)
              SlideRightFade(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'e-Cards',
                      actionLabel: 'All Cards',
                      onActionTap: () => _showAllCardsModal(context),
                    ),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          DigitalInsuranceCardWidget(
                            card: state.digitalCard,
                          ),
                          const SizedBox(width: 14),
                          // Peeking secondary card
                          _buildSecondaryCard(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 5. Latest Teleconsult Section (Slides up with fade)
              if (state.latestTeleconsult != null)
                SlideUpFade(
                  delay: const Duration(milliseconds: 380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Latest Teleconsult'),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildTeleconsultCard(context, state.latestTeleconsult!),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 28),

              // 6. Active Policies Quick Section (Slides up with fade)
              SlideUpFade(
                delay: const Duration(milliseconds: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Active Policies',
                      actionLabel: 'View All (${state.policies.length})',
                      onActionTap: () {
                        state.setNavIndex(1);
                      },
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: state.policies.map((policy) {
                          return _buildPolicyQuickTile(context, policy);
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

  String _getEventAssetPath(String heroTheme) {
    switch (heroTheme) {
      case 'gamification':
        return 'assets/images/event_gamification.jpg';
      case 'summit':
        return 'assets/images/event_summit.jpg';
      case 'wellness':
      default:
        return 'assets/images/event_wellness.jpg';
    }
  }

  Widget _buildEventCard(BuildContext context, InsuranceEvent event) {
    final imagePath = _getEventAssetPath(event.heroTheme);

    return Container(
      width: 235,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neutralBorder.withValues(alpha: 0.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEventDetailModal(context, event),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event Hero Banner with Editorial Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                child: SizedBox(
                  height: 122,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CustomPaint(
                            painter: _EventThumbnailPainter(theme: event.heroTheme),
                          );
                        },
                      ),
                      // Soft gradient overlay for contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.22),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.15),
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                      // Category Tag Badge (Frosted pill)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            event.tag,
                            style: AppTypography.caption.copyWith(
                              color: event.badgeText,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ),
                      // Bookmark Icon
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_outline_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title & Read time
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.h3.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1816),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 13,
                              color: Color(0xFF9E9995),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.readTime,
                              style: AppTypography.caption.copyWith(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7A7570),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F2EE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: Color(0xFF4A4440),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAllCardsModal(context),
      child: Container(
        width: 70,
        height: 165,
        decoration: BoxDecoration(
          color: const Color(0xFFDCD8D3),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 12,
              top: 48,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user_avatar_2.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF6B7280),
                        child: const Icon(Icons.person, color: Colors.white, size: 24),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeleconsultCard(BuildContext context, TeleconsultAppointment consult) {
    final avatarImg = consult.avatarImagePath ?? 'assets/images/doctor_avatar.jpg';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor row
          Row(
            children: [
              // Avatar with doctor photo
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E2DB),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarImg,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          consult.avatarInitials,
                          style: AppTypography.h3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consult.doctorName,
                      style: AppTypography.h3.copyWith(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1816),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF28F5A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            consult.type,
                            style: AppTypography.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F5F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE8E5E0)),
                          ),
                          child: Text(
                            consult.dateTime,
                            style: AppTypography.caption.copyWith(
                              color: const Color(0xFF4A4440),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFECEAE5), height: 1, thickness: 1),
          const SizedBox(height: 14),

          // Checkmarks
          _buildCheckItem('Lab Test Booking Option Available'),
          const SizedBox(height: 8),
          _buildCheckItem('Digital Prescription Issued (Covered by Insurance)'),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFF1E1816),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF2C2724),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyQuickTile(BuildContext context, Policy policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onSelectPolicy(policy),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2EE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.neutralBorder, width: 1),
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
                    policy.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Policy #${policy.policyNumber} • Renewal ${policy.renewalDate}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${policy.coverageAmount.toStringAsFixed(0)}',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Coverage',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadStatementModal(BuildContext context) {
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
              Text('Download Policy Statements', style: AppTypography.h2),
              const SizedBox(height: 12),
              Text(
                'Select the policy document statements to export for tax or personal records.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 20),
              ...state.policies.map((p) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                    title: Text(p.name, style: AppTypography.bodyLarge),
                    subtitle: Text('Policy #${p.policyNumber}', style: AppTypography.caption),
                    trailing: IconButton(
                      icon: const Icon(Icons.download_rounded, color: AppColors.primaryDark),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading statement for ${p.name}...')),
                        );
                      },
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTopUpModal(BuildContext context) {
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
              Text('Health Savings & HSA Top Up', style: AppTypography.h2),
              const SizedBox(height: 8),
              Text(
                'Add funds to your dedicated cashless healthcare reserve.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _amountChip(context, '\$100'),
                  _amountChip(context, '\$250'),
                  _amountChip(context, '\$500'),
                  _amountChip(context, '\$1,000'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _amountChip(BuildContext context, String amount) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deposited $amount to healthcare wallet!')),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutralLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.neutralBorder),
        ),
        child: Text(amount, style: AppTypography.button.copyWith(color: AppColors.primaryDark)),
      ),
    );
  }

  void _showConciergeChatModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Insurance Concierge', style: AppTypography.h2),
                        Text('24/7 Policy & Claim Assistance', style: AppTypography.caption),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _buildChatBubble('Hello Willie! I am your Antigravity Insurance Assistant. How can I help you today? (e.g. Check claim status, submit receipt, hospital network lookup)', false),
                      _buildChatBubble('Is Harmony General Hospital covered under my Platinum Health plan?', true),
                      _buildChatBubble('Yes, Harmony General Hospital on Fenimore St 22A is an In-Network Cashless Partner under your Platinum Comprehensive Health policy #HLT-99201.', false),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutralLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your question...',
                            border: InputBorder.none,
                            hintStyle: AppTypography.caption,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryDark : const Color(0xFFF1EFEB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: isUser ? Colors.white : AppColors.primaryDark,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  void _showEventDetailModal(BuildContext context, InsuranceEvent event) {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: event.badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(event.tag, style: AppTypography.captionBold.copyWith(color: event.badgeText)),
              ),
              const SizedBox(height: 12),
              Text(event.title, style: AppTypography.h2),
              const SizedBox(height: 8),
              Text('Estimated read: ${event.readTime} • Published this week', style: AppTypography.caption),
              const SizedBox(height: 16),
              Text(
                'Explore how modern digital policy management, automated claims assessment, and preventative wellness credits are transforming policyholder satisfaction across global insurance ecosystems.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showAllCardsModal(BuildContext context) {
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
              Text('Digital Insurance Passes', style: AppTypography.h2),
              const SizedBox(height: 8),
              Text('Your active membership cards and emergency QR codes.', style: AppTypography.bodySecondary),
              const SizedBox(height: 20),
              DigitalInsuranceCardWidget(card: state.digitalCard),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _EventThumbnailPainter extends CustomPainter {
  final String theme;

  _EventThumbnailPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    List<Color> colors;
    if (theme == 'summit') {
      colors = const [Color(0xFF4A6572), Color(0xFF232F34)];
    } else if (theme == 'wellness') {
      colors = const [Color(0xFF5B8A72), Color(0xFF2C4A3E)];
    } else {
      colors = const [Color(0xFFD67353), Color(0xFF8C3E26)];
    }

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Dynamic wave curves
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _EventThumbnailPainter oldDelegate) =>
      oldDelegate.theme != theme;
}
