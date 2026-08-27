import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ProtectionArtwork extends StatefulWidget {
  const ProtectionArtwork({super.key});

  @override
  State<ProtectionArtwork> createState() => _ProtectionArtworkState();
}

class _ProtectionArtworkState extends State<ProtectionArtwork>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final floatVal = math.sin(_floatController.value * math.pi * 2) * 5;
          final floatVal2 = math.cos(_floatController.value * math.pi * 2) * 4;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1. Soft Warm Ambient Glow Orb Behind Artwork
              Container(
                width: 290,
                height: 290,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.20),
                      const Color(0xFFF3E2DB).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),

              // 2. Main Architectural Hero Canvas (Premium Framed Photography)
              Transform.translate(
                offset: Offset(0, floatVal * 0.4),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E1816).withValues(alpha: 0.14),
                        blurRadius: 36,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/splash_hero.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF6F3EE),
                              child: const Center(
                                child: Icon(
                                  Icons.home_work_rounded,
                                  size: 64,
                                  color: Color(0xFFD67543),
                                ),
                              ),
                            );
                          },
                        ),
                        // Warm cinematic vignette & bottom fade
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.04),
                                const Color(0xFF1E1816).withValues(alpha: 0.25),
                              ],
                              stops: const [0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Floating Feature Badge 1 (Top Right): ⚡ Instant Claims
              Positioned(
                top: 18 + floatVal,
                right: 8,
                child: _buildBadge(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFEAA023),
                  iconBg: const Color(0xFFFEF7E6),
                  title: 'Instant Claims',
                  subtitle: 'Avg. 90s Approval',
                ),
              ),

              // 4. Floating Feature Badge 2 (Top Left): 🛡️ 100% Cashless
              Positioned(
                top: 42 - floatVal,
                left: 8,
                child: _buildBadge(
                  icon: Icons.shield_rounded,
                  iconColor: AppColors.primary,
                  iconBg: const Color(0xFFFDEEE9),
                  title: '100% Cashless',
                  subtitle: 'Zero Paperwork',
                ),
              ),

              // 5. Floating Feature Badge 3 (Bottom Left): 🏥 5,000+ Clinics
              Positioned(
                bottom: 18 + floatVal2,
                left: 12,
                child: _buildBadge(
                  icon: Icons.local_hospital_rounded,
                  iconColor: const Color(0xFF2E7D32),
                  iconBg: const Color(0xFFE8F5E9),
                  title: '5,000+ Clinics',
                  subtitle: 'Direct Billing',
                ),
              ),

              // 6. Floating Feature Badge 4 (Bottom Right): ★ 4.95 Rating
              Positioned(
                bottom: 32 - floatVal2,
                right: 10,
                child: _buildBadge(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFEAA023),
                  iconBg: const Color(0xFFFEF7E6),
                  title: '4.95 ★ Rating',
                  subtitle: '250k+ Protected',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.captionBold.copyWith(
                  color: const Color(0xFF1E1816),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF7A7570),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
