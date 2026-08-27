import 'package:flutter/material.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_animations.dart';
import '../../main.dart';
import 'widgets/expanding_start_button.dart';
import 'widgets/protection_artwork.dart';

class SplashScreen extends StatefulWidget {
  final InsuranceState state;

  const SplashScreen({
    super.key,
    required this.state,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToMainShell() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return MainAppShell(state: widget.state);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE), // Warm editorial cream surface
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Minimal Header (Skip Button, No Antigravity Logo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Subtle brand dot & category label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE6DC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'INSURANCE',
                              style: AppTypography.captionBold.copyWith(
                                color: const Color(0xFF4A4440),
                                fontSize: 10.5,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Skip Button
                      TextButton(
                        onPressed: _navigateToMainShell,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF7A7570),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text(
                          'Skip',
                          style: AppTypography.captionBold.copyWith(
                            color: const Color(0xFF7A7570),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 2. Central Editorial Artwork with Floating Badges (Slides Down)
                const SlideDownFade(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ProtectionArtwork(),
                  ),
                ),

                const SizedBox(height: 22),

                // 3. Hero Typography & Action Controls (Slides up)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline Pill
                      SlideRightFade(
                        delay: const Duration(milliseconds: 100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDEEE9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Calm & Transparent Coverage',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.primary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Display Headline
                      SlideDownFade(
                        delay: const Duration(milliseconds: 150),
                        verticalOffset: -0.15,
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.display.copyWith(
                              fontSize: 34,
                              height: 1.15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1816),
                              letterSpacing: -0.8,
                            ),
                            children: const [
                              TextSpan(text: 'Peace of mind,\n'),
                              TextSpan(
                                text: 'crafted simply.',
                                style: TextStyle(
                                  color: Color(0xFFD67543),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      SlideRightFade(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          'Intelligent protection designed around your life. Zero paperwork, instantaneous cashless claims, and 24/7 care.',
                          style: AppTypography.bodySecondary.copyWith(
                            fontSize: 14.5,
                            height: 1.5,
                            color: const Color(0xFF5A5452),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Expanding Start CTA
                      SlideUpFade(
                        delay: const Duration(milliseconds: 250),
                        child: Center(
                          child: ExpandingStartButton(
                            label: 'Get Started',
                            onTap: _navigateToMainShell,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Trust Footer
                      SlideUpFade(
                        delay: const Duration(milliseconds: 300),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 13,
                                  color: Color(0xFF9E9995),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Regulated • Bank-grade 256-bit encryption',
                                  style: AppTypography.caption.copyWith(
                                    color: const Color(0xFF9E9995),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
