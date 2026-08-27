import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DigitalInsuranceCardWidget extends StatefulWidget {
  final DigitalCard card;
  final VoidCallback? onTap;

  const DigitalInsuranceCardWidget({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  State<DigitalInsuranceCardWidget> createState() => _DigitalInsuranceCardWidgetState();
}

class _DigitalInsuranceCardWidgetState extends State<DigitalInsuranceCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isBackVisible = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isBackVisible) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isBackVisible = !_isBackVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          final isUnderHalf = _flipAnimation.value < 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isUnderHalf ? _buildFront() : Transform(
              transform: Matrix4.identity()..rotateY(math.pi),
              alignment: Alignment.center,
              child: _buildBack(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final avatarPath = widget.card.avatarImagePath ?? 'assets/images/user_avatar.jpg';

    return Container(
      width: 310,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCE4D31).withValues(alpha: 0.32),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE87352),
            Color(0xFFDC5E40),
            Color(0xFFB54124),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background subtle fluid organic shapes
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: _CardGlowPainter(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: Card ID on the top right
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    widget.card.cardId,
                    style: AppTypography.h2.copyWith(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                // Bottom row: Avatar & Holder details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Member Avatar Circle with real photo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          avatarPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF381F1A),
                              child: Center(
                                child: Text(
                                  'WS',
                                  style: AppTypography.button.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.card.holderName,
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.card.tier,
                            style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildBack() {
    return Container(
      width: 310,
      height: 165,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HEALTH & ACCIDENT PASS',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'EXP: ${widget.card.validThru}',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Mock Barcode
            Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: _BarcodePainter(),
              ),
            ),
            Center(
              child: Text(
                'Tap card to flip back',
                style: AppTypography.caption.copyWith(
                  color: AppColors.softPeach,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.4, -0.4),
        radius: 0.8,
        colors: [
          const Color(0xFFFF9A72).withValues(alpha: 0.4),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.3), size.width * 0.5, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double x = 4;
    final widths = [2.0, 4.0, 1.5, 3.0, 5.0, 2.0, 1.0, 4.0, 2.5, 1.5, 3.5, 2.0, 5.0, 1.5, 3.0, 2.0, 4.0];
    int index = 0;

    while (x < size.width - 10) {
      final w = widths[index % widths.length];
      canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), barPaint);
      x += w + 2.5;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
