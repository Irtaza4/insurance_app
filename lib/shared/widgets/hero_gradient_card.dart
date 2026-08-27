import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

/// Top Hero card with warm terracotta ambient mesh gradient,
/// claims progress pill, and embedded upcoming premiums overlay card,
/// matching the exact reference design.
class HeroGradientCard extends StatelessWidget {
  final String greeting;
  final String userName;
  final int activeClaimsCount;
  final int upcomingPremiumsCount;
  final int dueDays;
  final double totalPremiumAmount;
  final VoidCallback onClaimsTap;
  final VoidCallback onViewPremiumTap;

  const HeroGradientCard({
    super.key,
    required this.greeting,
    required this.userName,
    required this.activeClaimsCount,
    required this.upcomingPremiumsCount,
    required this.dueDays,
    required this.totalPremiumAmount,
    required this.onClaimsTap,
    required this.onViewPremiumTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2431F).withValues(alpha: 0.25),
            blurRadius: 36,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          children: [
            // Exact Mesh Gradient Canvas
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroMeshGradientPainter(),
              ),
            ),

            // Content Column
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Greeting: "Welcome Back"
                  Text(
                    greeting,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // User Name: "Willie Schulist"
                  Text(
                    userName,
                    style: AppTypography.displayLight.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Claims In Progress Translucent Banner Pill
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClaimsTap,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.62),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.65),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Serrated Ticket Badge Icon with number 2
                            CustomPaint(
                              size: const Size(38, 38),
                              painter: _SerratedTicketPainter(count: activeClaimsCount),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'You have $activeClaimsCount claims in progress',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E1816),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xFF5A524E),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3 Upcoming Premiums Floating Card (Exact Match)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1816).withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top info with rolled document graphic
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$upcomingPremiumsCount Upcoming Premiums',
                                    style: AppTypography.h2.copyWith(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1816),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled_rounded,
                                        size: 15,
                                        color: Color(0xFFACAAA8),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Due in $dueDays days',
                                        style: AppTypography.caption.copyWith(
                                          color: const Color(0xFF8C8681),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Curled Rolled Document Graphic
                            CustomPaint(
                              size: const Size(60, 52),
                              painter: _CurledDocumentPainter(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Bottom Row: Price & Dark Pill Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${totalPremiumAmount.toStringAsFixed(2)}',
                                style: AppTypography.h1.copyWith(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E1816),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onViewPremiumTap,
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                                  child: Text(
                                    'View Premium',
                                    style: AppTypography.button.copyWith(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the vibrant terracotta/peach/vermilion mesh gradient
class _HeroMeshGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Base background gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color(0xFFFF7A52),
        Color(0xFFEA4D2A),
        Color(0xFFD63B19),
        Color(0xFFF5CBB8),
      ],
      stops: const [0.0, 0.35, 0.75, 1.0],
    );

    canvas.drawRect(rect, Paint()..shader = baseGradient.createShader(rect));

    // Top-left light warm peach burst
    final glow1 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, -0.9),
        radius: 1.1,
        colors: [
          const Color(0xFFFFC5AC).withValues(alpha: 0.95),
          const Color(0x00FF7A52),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, glow1);

    // Center fiery coral splash
    final glow2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.4, -0.2),
        radius: 0.85,
        colors: [
          const Color(0xFFFF5228).withValues(alpha: 0.9),
          const Color(0x00D63B19),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, glow2);

    // Bottom soft pastel apricot blend
    final glow3 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.9, 0.9),
        radius: 1.0,
        colors: [
          const Color(0xFFF7D2C2).withValues(alpha: 0.85),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, glow3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the exact orange serrated receipt ticket badge from Image 2
class _SerratedTicketPainter extends CustomPainter {
  final int count;

  _SerratedTicketPainter({required this.count});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Circular orange gradient background
    final circleRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final circlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFA756),
          Color(0xFFE85420),
        ],
      ).createShader(circleRect);

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.5, circlePaint);

    // 2. Inner ticket shape with serrated bottom edge
    final ticketRect = Rect.fromLTWH(7, 6, size.width - 14, size.height - 13);
    final ticketPath = Path()
      ..moveTo(ticketRect.left + 4, ticketRect.top)
      ..lineTo(ticketRect.right - 4, ticketRect.top)
      ..arcToPoint(Offset(ticketRect.right, ticketRect.top + 4), radius: const Radius.circular(4))
      ..lineTo(ticketRect.right, ticketRect.bottom - 4)
      // Serrated zigzag bottom
      ..lineTo(ticketRect.right - 4, ticketRect.bottom)
      ..lineTo(ticketRect.right - 8, ticketRect.bottom - 3)
      ..lineTo(ticketRect.right - 12, ticketRect.bottom)
      ..lineTo(ticketRect.right - 16, ticketRect.bottom - 3)
      ..lineTo(ticketRect.left + 4, ticketRect.bottom)
      ..lineTo(ticketRect.left, ticketRect.bottom - 4)
      ..lineTo(ticketRect.left, ticketRect.top + 4)
      ..arcToPoint(Offset(ticketRect.left + 4, ticketRect.top), radius: const Radius.circular(4))
      ..close();

    final ticketPaint = Paint()..color = const Color(0xFFF9E4D4);
    canvas.drawPath(ticketPath, ticketPaint);

    // 3. Number text
    final textSpan = TextSpan(
      text: '$count',
      style: const TextStyle(
        color: Color(0xFF1E1816),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2 - 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _SerratedTicketPainter oldDelegate) =>
      oldDelegate.count != count;
}

/// Custom painter for the exact curled rolled parchment document from Image 2
class _CurledDocumentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base sheet background (translucent light grey/white)
    final sheetPath = Path()
      ..moveTo(6, 4)
      ..lineTo(size.width - 8, 4)
      ..arcToPoint(Offset(size.width - 4, 8), radius: const Radius.circular(4))
      ..lineTo(size.width - 4, size.height - 18)
      ..lineTo(6, size.height - 18)
      ..arcToPoint(const Offset(2, 8), radius: const Radius.circular(4))
      ..close();

    final sheetPaint = Paint()..color = const Color(0xFFF3F2EE);
    canvas.drawPath(sheetPath, sheetPaint);

    // 2. Three horizontal document lines
    final linePaint = Paint()
      ..color = const Color(0xFFE0DBD5)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(12, 14), Offset(size.width - 14, 14), linePaint);
    canvas.drawLine(const Offset(12, 22), Offset(size.width - 24, 22), linePaint);
    canvas.drawLine(const Offset(12, 30), Offset(size.width - 32, 30), linePaint);

    // 3. Cylindrical rolled curl at the bottom right
    final rollRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height - 20, size.width, 18),
      const Radius.circular(9),
    );
    final rollPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE7E3DC),
          Color(0xFFD6D0C8),
        ],
      ).createShader(Rect.fromLTWH(0, size.height - 20, size.width, 18));
    canvas.drawRRect(rollRect, rollPaint);

    // End curl highlight
    final curlCap = Paint()..color = const Color(0xFFC7C0B7);
    canvas.drawCircle(Offset(size.width - 9, size.height - 11), 7.5, curlCap);
    canvas.drawCircle(Offset(size.width - 9, size.height - 11), 4.5, Paint()..color = const Color(0xFFECE7E1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
