import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class ServiceIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? customIcon;

  const ServiceIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF1E1816).withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1816).withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Light grey circular container for icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F1ED),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: customIcon ??
                      Icon(
                        icon,
                        size: 16,
                        color: const Color(0xFF524C49),
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1816),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
