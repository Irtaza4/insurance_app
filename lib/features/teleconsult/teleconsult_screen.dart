import 'package:flutter/material.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/buttons_and_inputs.dart';

class TeleconsultScreen extends StatelessWidget {
  final InsuranceState state;

  const TeleconsultScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final consult = state.latestTeleconsult;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Teleconsultation',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Consultation Card
            if (consult != null) ...[
              Text('Upcoming Appointment', style: AppTypography.h2.copyWith(fontSize: 18)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6E8E2),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.softPeach, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              consult.avatarInitials,
                              style: AppTypography.h2.copyWith(color: AppColors.primary, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(consult.doctorName, style: AppTypography.h2.copyWith(fontSize: 18)),
                              const SizedBox(height: 2),
                              Text(consult.specialty, style: AppTypography.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.neutralLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.videocam_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(consult.dateTime, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _benefitCheck('100% Covered under Comprehensive Health Plan #HLT-99201'),
                    const SizedBox(height: 8),
                    _benefitCheck('Digital prescription auto-sent to in-network pharmacy'),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Join Video Consultation Room',
                      leadingIcon: Icons.videocam_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connecting to encrypted telemedicine room...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Available Doctors List
            Text('Book New In-Network Specialist', style: AppTypography.h2.copyWith(fontSize: 18)),
            const SizedBox(height: 12),

            _buildDoctorRow(
              context,
              name: 'Dr. Marcus Vance',
              specialty: 'Cardiologist & Preventive Health',
              rating: '4.9 (128 reviews)',
              initials: 'MV',
            ),
            _buildDoctorRow(
              context,
              name: 'Dr. Sophia Reyes',
              specialty: 'Dermatologist & Oral Medicine',
              rating: '4.95 (210 reviews)',
              initials: 'SR',
            ),
            _buildDoctorRow(
              context,
              name: 'Dr. Nathan Reed',
              specialty: 'Orthopedic & Sports Medicine',
              rating: '4.85 (94 reviews)',
              initials: 'NR',
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitCheck(String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTypography.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildDoctorRow(
    BuildContext context, {
    required String name,
    required String specialty,
    required String rating,
    required String initials,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F2EE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(initials, style: AppTypography.captionBold.copyWith(color: AppColors.primaryDark)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.h3.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(specialty, style: AppTypography.caption),
                const SizedBox(height: 2),
                Text('⭐ $rating', style: AppTypography.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              minimumSize: const Size(70, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appointment requested with $name!')),
              );
            },
            child: Text('Book', style: AppTypography.captionBold.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
