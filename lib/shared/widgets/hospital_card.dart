import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final bool isCompact;
  final VoidCallback onDirectionTap;
  final VoidCallback onCallTap;
  final VoidCallback onMoreTap;

  const HospitalCard({
    super.key,
    required this.hospital,
    this.isCompact = false,
    required this.onDirectionTap,
    required this.onCallTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactListCard(context);
    }
    return _buildExpandedCarouselCard(context);
  }

  String _getImageAssetPath(String imageType) {
    switch (imageType) {
      case 'brick_clinic':
        return 'assets/images/hospital_vitalspring.jpg';
      case 'glass_wing':
        return 'assets/images/hospital_parkside.jpg';
      case 'modern_facade':
      default:
        return 'assets/images/hospital_harmony.jpg';
    }
  }

  /// Large card shown in Map / Carousel view (Exact Match with Reference Image Left Screen)
  Widget _buildExpandedCarouselCard(BuildContext context) {
    return Container(
      width: 325,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.10),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Building Visual Banner with Modern Architectural Photography
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: SizedBox(
              height: 175,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _getImageAssetPath(hospital.imageType),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CustomPaint(
                        painter: _ArchitecturalApexBuildingPainter(),
                      );
                    },
                  ),
                  // Bottom smooth gradient fade into white card surface
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.8),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Details & Category Badge & Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Pill Badge (Peach with dark brown text matching Reference)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5.5),
                  decoration: BoxDecoration(
                    color: _getCategoryBgColor(hospital.categoryLabel),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    hospital.categoryLabel,
                    style: AppTypography.captionBold.copyWith(
                      color: const Color(0xFF381F1A),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Hospital Name: Harmony General Hospital
                Text(
                  hospital.name,
                  style: AppTypography.h2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E1816),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Location / Distance: "📍 Fenimore St 22A (2.3km)"
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: Color(0xFFACAAA8),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: AppTypography.bodySecondary.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5A5452),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Hours Status: "📍 Open • Close at 23:30"
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: Color(0xFFACAAA8),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        hospital.openStatus,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF5A5452),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons Row: [↗ Direction] [📞] [•••]
                Row(
                  children: [
                    // Direction Button
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onDirectionTap,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF484340),
                                  Color(0xFF24201E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E1816).withValues(alpha: 0.28),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.north_east_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Direction',
                                  style: AppTypography.button.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Phone Call Button
                    _buildCircleIconButton(
                      icon: Icons.phone_outlined,
                      onTap: onCallTap,
                    ),
                    const SizedBox(width: 10),

                    // More Options Button
                    _buildCircleIconButton(
                      icon: Icons.more_horiz_rounded,
                      onTap: onMoreTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Compact List Card shown in Floating List View (Exact Match with Reference Image Right Screen)
  Widget _buildCompactListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neutralBorder.withValues(alpha: 0.7), width: 1),
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
          onTap: onDirectionTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail building with right gradient blend into white
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 86,
                    height: 82,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _getImageAssetPath(hospital.imageType),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CustomPaint(
                              painter: _ArchitecturalApexBuildingPainter(),
                            );
                          },
                        ),
                        // Right edge fade
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          width: 28,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: 0.8),
                                  Colors.white,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryBgColor(hospital.categoryLabel),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hospital.categoryLabel,
                          style: AppTypography.caption.copyWith(
                            color: const Color(0xFF381F1A),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Name: e.g. Harmony General Hospital / VitalSpring Medical
                      Text(
                        hospital.name,
                        style: AppTypography.h3.copyWith(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1816),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Address: 📍 Fenimore St 22A (2.3km)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFFACAAA8),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hospital.address,
                              style: AppTypography.caption.copyWith(
                                color: const Color(0xFF6B6663),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F1ED),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1E1816).withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFF1E1816),
          ),
        ),
      ),
    );
  }

  Color _getCategoryBgColor(String category) {
    if (category.contains('Dental') || category.contains('Oral')) {
      return const Color(0xFFFFD1C2);
    }
    if (category.contains('Mental') || category.contains('Behavioral')) {
      return const Color(0xFFE2E4EB);
    }
    return const Color(0xFFFFB692); // Default warm peach
  }
}

/// Fallback Apex Building Painter
class _ArchitecturalApexBuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFCDD6DF), Color(0xFFE4E9EF), Color(0xFFEEF2F6)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    final apex = Offset(w * 0.54, h * 0.16);
    final leftHorizon = Offset(-w * 0.05, h * 0.95);
    final rightHorizon = Offset(w * 1.05, h * 0.95);
    final centerBase = Offset(apex.dx, h * 1.0);

    final rightFacade = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(rightHorizon.dx, rightHorizon.dy)
      ..lineTo(centerBase.dx, centerBase.dy)
      ..close();

    canvas.drawPath(
      rightFacade,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFD67543), Color(0xFFBE5E2E), Color(0xFFA24A1E)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final leftFacade = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(leftHorizon.dx, leftHorizon.dy)
      ..lineTo(centerBase.dx, centerBase.dy)
      ..close();

    canvas.drawPath(
      leftFacade,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF7F9FA), Color(0xFFCFD6DF), Color(0xFF98A6B5)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
