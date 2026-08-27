import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildNavItem(
                  index: 0,
                  iconType: _NavIconType.home,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 1,
                  iconType: _NavIconType.claims,
                  label: 'Claims',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 2,
                  iconType: _NavIconType.rewards,
                  label: 'Rewards',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 3,
                  iconType: _NavIconType.more,
                  label: 'More',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required _NavIconType iconType,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFF24201E) : const Color(0xFFACAAA8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CustomPaint(
                  painter: _NavIconPainter(
                    type: iconType,
                    color: color,
                    isSelected: isSelected,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _NavIconType { home, claims, rewards, more }

class _NavIconPainter extends CustomPainter {
  final _NavIconType type;
  final Color color;
  final bool isSelected;

  _NavIconPainter({
    required this.type,
    required this.color,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case _NavIconType.home:
        _drawHomeIcon(canvas, size, paint);
        break;
      case _NavIconType.claims:
        _drawClaimsIcon(canvas, size, paint);
        break;
      case _NavIconType.rewards:
        _drawRewardsIcon(canvas, size, paint);
        break;
      case _NavIconType.more:
        _drawMoreIcon(canvas, size, paint);
        break;
    }
  }

  /// Exact Home Tote/Pouch Icon from Image 1
  void _drawHomeIcon(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    // Rounded pouch/tote body
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(3, 4, size.width - 6, size.height - 5),
      const Radius.circular(7),
    );
    path.addRRect(rrect);

    // Handle slot cutout
    final cutout = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(7, 7, size.width - 14, 4.5),
          const Radius.circular(2.5),
        ),
      );

    final finalPath = Path.combine(PathOperation.difference, path, cutout);
    canvas.drawPath(finalPath, paint);
  }

  /// Exact Folder Icon for Claims from Image 1
  void _drawClaimsIcon(Canvas canvas, Size size, Paint paint) {
    final strokePaint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(4, 8)
      ..lineTo(10, 8)
      ..lineTo(13, 11)
      ..lineTo(size.width - 4, 11)
      ..arcToPoint(Offset(size.width - 2, 13), radius: const Radius.circular(2))
      ..lineTo(size.width - 2, size.height - 4)
      ..arcToPoint(Offset(size.width - 4, size.height - 2), radius: const Radius.circular(3))
      ..lineTo(4, size.height - 2)
      ..arcToPoint(Offset(2, size.height - 4), radius: const Radius.circular(3))
      ..lineTo(2, 10)
      ..arcToPoint(const Offset(4, 8), radius: const Radius.circular(2))
      ..close();

    if (isSelected) {
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(path, strokePaint);
    }
  }

  /// Exact Gift Box with Ribbon Bow Icon for Rewards from Image 1
  void _drawRewardsIcon(Canvas canvas, Size size, Paint paint) {
    // Bow circles
    final bowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(size.width * 0.38, 7), 3.5, bowPaint);
    canvas.drawCircle(Offset(size.width * 0.62, 7), 3.5, bowPaint);

    // Box lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 9, size.width - 8, 4),
      const Radius.circular(2),
    );
    canvas.drawRRect(lidRect, Paint()..color = color);

    // Box bottom
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(5, 14, size.width - 10, size.height - 16),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(boxRect, Paint()..color = color);

    // Vertical ribbon gap
    final ribbonGap = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width * 0.5, 9), Offset(size.width * 0.5, size.height - 2), ribbonGap);
  }

  /// Exact 3-Circle Pyramid More Icon from Image 1
  void _drawMoreIcon(Canvas canvas, Size size, Paint paint) {
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Top dot
    canvas.drawCircle(Offset(size.width * 0.5, 8), 3.6, dotPaint);
    // Bottom-left dot
    canvas.drawCircle(Offset(size.width * 0.32, 19), 3.6, dotPaint);
    // Bottom-right dot
    canvas.drawCircle(Offset(size.width * 0.68, 19), 3.6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.type != type ||
      oldDelegate.isSelected != isSelected;
}
