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

  /// Large card shown in Map / Carousel view (Exact Match with Image 2)
  Widget _buildExpandedCarouselCard(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Building Visual Banner with Category Badge
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: SizedBox(
              height: 185,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ArchitecturalBuildingPainter(),
                    ),
                  ),
                  // Soft bottom gradient fade into card surface
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
                            Colors.white.withValues(alpha: 0.85),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category Pill Badge (Peach with dark text matching Reference)
                  Positioned(
                    bottom: 8,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB692),
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
                  ),
                ],
              ),
            ),
          ),

          // Details & Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title: Harmony General Hospital
                Text(
                  hospital.name,
                  style: AppTypography.h2.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E1816),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Location / Distance: "📍 Fenimore St 22A (2.3km)"
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 17,
                      color: Color(0xFFACAAA8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: AppTypography.bodySecondary.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5A5452),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Open Status: "📍 Open • Close at 23:30"
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled_rounded,
                      size: 16,
                      color: Color(0xFFACAAA8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hospital.openStatus,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF5A5452),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Actions Row
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
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF423D3A),
                                  Color(0xFF24201E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E1816).withValues(alpha: 0.3),
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
                                  size: 16,
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

  /// Compact List Card shown in Full List View
  Widget _buildCompactListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1816).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDirectionTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail building
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 78,
                    height: 78,
                    child: CustomPaint(
                      painter: _ArchitecturalBuildingPainter(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB692),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hospital.categoryLabel,
                          style: AppTypography.caption.copyWith(
                            color: const Color(0xFF381F1A),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Name
                      Text(
                        hospital.name,
                        style: AppTypography.h3.copyWith(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Address
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.textGray,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              hospital.address,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textGray,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.textGray,
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F1ED),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1E1816).withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF1E1816),
          ),
        ),
      ),
    );
  }
}

/// Custom painter rendering the exact modern architectural building facade shown in Image 2
class _ArchitecturalBuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sky background
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFD6DBE0),
          Color(0xFFE9ECF0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // Architectural Apex Perspective (Points upward-right matching Image 2)
    final apex = Offset(size.width * 0.52, size.height * 0.12);

    // Left Facade (Light Concrete & Glass Ribbon Windows)
    final leftFacade = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(size.width * 0.05, size.height * 0.85)
      ..lineTo(apex.dx, size.height * 0.85)
      ..close();

    final leftPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFFF2F4F7),
          Color(0xFFC0C7D0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(leftFacade, leftPaint);

    // Right Facade (Warm Honey Cedar Timber Paneling matching Image 2)
    final rightFacade = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(size.width * 0.88, size.height * 0.85)
      ..lineTo(apex.dx, size.height * 0.85)
      ..close();

    final rightPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD37B47),
          Color(0xFFB55D2E),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(rightFacade, rightPaint);

    // Left Window Bands
    final windowPaint = Paint()
      ..color = const Color(0xFF2B3A48).withValues(alpha: 0.75)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 6; i++) {
      final t = i / 7.0;
      final y = apex.dy + (size.height * 0.85 - apex.dy) * t;
      final xLeft = apex.dx - (apex.dx - size.width * 0.05) * t;
      canvas.drawLine(Offset(apex.dx, y), Offset(xLeft, y + 2), windowPaint);
    }

    // Right Window Slats / Timber Louvers
    final timberLouverPaint = Paint()
      ..color = const Color(0xFF753618).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 8; i++) {
      final t = i / 9.0;
      final y = apex.dy + (size.height * 0.85 - apex.dy) * t;
      final xRight = apex.dx + (size.width * 0.88 - apex.dx) * t;
      canvas.drawLine(Offset(apex.dx, y), Offset(xRight, y + 3), timberLouverPaint);
    }

    // Center vertical spine edge
    final spinePaint = Paint()
      ..color = const Color(0xFF4A2514)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(apex, Offset(apex.dx, size.height * 0.85), spinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
