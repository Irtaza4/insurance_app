import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  final InsuranceState state;

  const NotificationsScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final notifs = state.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTypography.h1.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: state.markAllNotificationsRead,
            child: Text('Mark all as read', style: AppTypography.button.copyWith(color: AppColors.primary, fontSize: 13)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifs.isEmpty
          ? Center(
              child: Text('No new notifications', style: AppTypography.bodySecondary),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifs[index];
                return _buildNotifCard(context, notif);
              },
            ),
    );
  }

  Widget _buildNotifCard(BuildContext context, AppNotification notif) {
    IconData icon;
    Color iconColor;

    if (notif.type == 'claim') {
      icon = Icons.pending_actions_rounded;
      iconColor = AppColors.primary;
    } else if (notif.type == 'payment') {
      icon = Icons.receipt_long_rounded;
      iconColor = AppColors.secondaryBrown;
    } else {
      icon = Icons.event_repeat_rounded;
      iconColor = AppColors.warmBeige;
    }

    return Container(
      decoration: BoxDecoration(
        color: notif.isUnread ? Colors.white : const Color(0xFFF9F7F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: notif.isUnread ? AppColors.softPeach : AppColors.neutralBorder,
          width: notif.isUnread ? 1.5 : 1,
        ),
        boxShadow: notif.isUnread
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF8EFEA),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(notif.title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
            Text(notif.timeAgo, style: AppTypography.caption),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(notif.description, style: AppTypography.bodySecondary),
        ),
        onTap: () => state.markNotificationRead(notif.id),
      ),
    );
  }
}
