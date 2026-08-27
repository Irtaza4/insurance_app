import 'package:flutter/material.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../notifications/notifications_screen.dart';
import '../payments/payments_screen.dart';
import '../policies/policies_screen.dart';

class ProfileScreen extends StatelessWidget {
  final InsuranceState state;

  const ProfileScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
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
          children: [
            // User Header Profile Card
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
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E2DB),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.softPeach, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'WS',
                        style: AppTypography.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.userName,
                          style: AppTypography.h2.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.statusActiveBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                state.memberTier,
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.statusActiveText,
                                  fontSize: 10.5,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'KYC Verified',
                                  style: AppTypography.caption.copyWith(
                                    color: const Color(0xFF2E7D32),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
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

            // Group 1: Account & Insurance
            _buildSection(
              title: 'Account & Management',
              items: [
                _ProfileItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal information',
                  subtitle: 'Name, address, contact details',
                  onTap: () => _showPersonalInfoModal(context),
                ),
                _ProfileItem(
                  icon: Icons.credit_card_rounded,
                  title: 'Payment methods',
                  subtitle: 'Visa •••• 4821, Apple Pay',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentsScreen(state: state)),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.folder_shared_outlined,
                  title: 'Documents & Certificates',
                  subtitle: 'All active policy schedules & tax forms',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoliciesScreen(state: state)),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Group 2: Preferences & Security
            _buildSection(
              title: 'Preferences & Security',
              items: [
                _ProfileItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: '${state.unreadNotificationCount} unread updates',
                  badgeCount: state.unreadNotificationCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen(state: state)),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Security & Biometrics',
                  subtitle: 'Face ID & App Passcode enabled',
                  onTap: () => _showSecurityModal(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Group 3: Support
            _buildSection(
              title: 'Emergency & Support',
              items: [
                _ProfileItem(
                  icon: Icons.headset_mic_outlined,
                  title: '24/7 Roadside & Health Hotline',
                  subtitle: 'Direct toll-free insurance dispatch',
                  onTap: () => _showEmergencyHotlineModal(context),
                ),
                _ProfileItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  subtitle: 'Coverage glossary & claims guide',
                  onTap: () => _showFaqModal(context),
                ),
                _ProfileItem(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  subtitle: 'Securely end session',
                  isDestructive: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out of session')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_ProfileItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTypography.captionBold.copyWith(
              color: AppColors.secondaryBrown,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.neutralBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) {
              final isLast = items.indexOf(item) == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.isDestructive ? const Color(0xFFFCE8E6) : const Color(0xFFF7F4F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.isDestructive ? AppColors.statusRejectedText : AppColors.primaryDark,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: item.isDestructive ? AppColors.statusRejectedText : AppColors.primaryDark,
                      ),
                    ),
                    subtitle: Text(item.subtitle, style: AppTypography.caption),
                    trailing: item.badgeCount != null && item.badgeCount! > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${item.badgeCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          )
                        : const Icon(Icons.chevron_right_rounded, color: AppColors.textGray, size: 20),
                    onTap: item.onTap,
                  ),
                  if (!isLast) const Divider(height: 1, color: AppColors.neutralBorder),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showPersonalInfoModal(BuildContext context) {
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
              Text('Personal Information', style: AppTypography.h2),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Full Name'),
                subtitle: Text(state.userName, style: AppTypography.bodyLarge),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Email Address'),
                subtitle: Text('willie.schulist@example.com', style: AppTypography.bodyLarge),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Registered Phone'),
                subtitle: Text('+1 (555) 019-2834', style: AppTypography.bodyLarge),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSecurityModal(BuildContext context) {
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
              Text('Security Settings', style: AppTypography.h2),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Biometric Authentication (Face ID)'),
                subtitle: const Text('Require Face ID to view claim payouts and e-Card'),
                value: true,
                activeTrackColor: AppColors.primary,
                onChanged: (v) {},
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Two-Factor Authentication (2FA)'),
                subtitle: const Text('SMS and email security code on new devices'),
                value: true,
                activeTrackColor: AppColors.primary,
                onChanged: (v) {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showEmergencyHotlineModal(BuildContext context) {
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
              Text('24/7 Emergency Hotlines', style: AppTypography.h2),
              const SizedBox(height: 8),
              Text('Priority dispatch lines with direct cashless clearance.', style: AppTypography.bodySecondary),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.car_crash_rounded, color: AppColors.primary),
                title: const Text('Roadside Collision & Towing Dispatch'),
                subtitle: const Text('1-800-555-ROAD (Toll Free)'),
                trailing: const Icon(Icons.phone_rounded, color: AppColors.primaryDark),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_hospital_rounded, color: Color(0xFF2E7D32)),
                title: const Text('Health & Emergency Medical Hotline'),
                subtitle: const Text('1-800-555-CARE (24 Hours)'),
                trailing: const Icon(Icons.phone_rounded, color: AppColors.primaryDark),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showFaqModal(BuildContext context) {
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
              Text('Help & Coverage FAQ', style: AppTypography.h2),
              const SizedBox(height: 16),
              const Text('• What is a deductible?\nThe amount you pay out of pocket before your coverage kicks in.'),
              const SizedBox(height: 12),
              const Text('• How does cashless hospitalization work?\nPresent your digital e-Card at any in-network partner hospital for direct insurance billing.'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isDestructive;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeCount,
    this.isDestructive = false,
  });
}
