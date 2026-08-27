import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/hospital_card.dart';
import '../../shared/widgets/interactive_map_canvas.dart';

class HospitalsScreen extends StatefulWidget {
  final InsuranceState state;
  final VoidCallback? onBack;

  const HospitalsScreen({
    super.key,
    required this.state,
    this.onBack,
  });

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final hospitals = state.filteredHospitals;

    return Scaffold(
      backgroundColor: const Color(0xFFEEEBE6),
      body: Stack(
        children: [
          // 1. Full Screen Interactive Map Background
          Positioned.fill(
            child: InteractiveMapCanvas(
              hospitals: hospitals,
              selectedHospital: state.selectedHospital,
              onSelectHospital: (hospital) {
                state.selectHospital(hospital);
                final index = hospitals.indexWhere((h) => h.id == hospital.id);
                if (index != -1 && _pageController.hasClients) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),

          // 2. Main Content (Map Carousel or Full List)
          SafeArea(
            child: Column(
              children: [
                // Top Custom App Bar (Back Button, Title, View Switcher Capsule)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Circular Back Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 22,
                              color: Color(0xFF1E1816),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title: "Hospitals"
                      Expanded(
                        child: Text(
                          'Hospitals',
                          style: AppTypography.h1.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1816),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),

                      // View Switcher Capsule (Card Mode vs List Mode)
                      Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2DED8).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Card/Map Carousel View Tab
                            _buildToggleTab(
                              isSelected: state.isHospitalMapView,
                              icon: Icons.crop_portrait_rounded,
                              onTap: () {
                                if (!state.isHospitalMapView) state.toggleHospitalView();
                              },
                            ),
                            // List View Tab
                            _buildToggleTab(
                              isSelected: !state.isHospitalMapView,
                              icon: Icons.menu_rounded,
                              onTap: () {
                                if (state.isHospitalMapView) state.toggleHospitalView();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content View
                Expanded(
                  child: state.isHospitalMapView
                      ? _buildMapCarouselView(context, state, hospitals)
                      : _buildFullListView(context, state, hospitals),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle Tab inside View Switcher Capsule
  Widget _buildToggleTab({
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF1E1816) : const Color(0xFF7A7570),
        ),
      ),
    );
  }

  /// Carousel view positioned at top over map with peek effect (Matching Image 2)
  Widget _buildMapCarouselView(
    BuildContext context,
    InsuranceState state,
    List<Hospital> hospitals,
  ) {
    if (hospitals.isEmpty) {
      return const Center(child: Text('No hospitals found in this category'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Floating Card Carousel
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: hospitals.length,
            onPageChanged: (index) {
              state.selectHospital(hospitals[index]);
            },
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return Padding(
                padding: const EdgeInsets.only(right: 14, left: 2),
                child: HospitalCard(
                  hospital: hospital,
                  onDirectionTap: () => _showNavigationModal(context, hospital),
                  onCallTap: () => _showCallDialer(context, hospital),
                  onMoreTap: () => _showHospitalDetailsModal(context, hospital),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Full List View with Category Chips and scrollable cards
  Widget _buildFullListView(
    BuildContext context,
    InsuranceState state,
    List<Hospital> hospitals,
  ) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.95),
      child: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: [
                _buildCategoryChip(state, 'All'),
                const SizedBox(width: 8),
                _buildCategoryChip(state, 'General & Primary Care'),
                const SizedBox(width: 8),
                _buildCategoryChip(state, 'Dental & Oral'),
                const SizedBox(width: 8),
                _buildCategoryChip(state, 'Mental & Behavioral Health'),
              ],
            ),
          ),

          // Cards list
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final hospital = hospitals[index];
                return HospitalCard(
                  hospital: hospital,
                  isCompact: true,
                  onDirectionTap: () => _showNavigationModal(context, hospital),
                  onCallTap: () => _showCallDialer(context, hospital),
                  onMoreTap: () => _showHospitalDetailsModal(context, hospital),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    InsuranceState state,
    String categoryName,
  ) {
    final isSelected = state.selectedHospitalCategory == categoryName;
    return ChoiceChip(
      label: Text(categoryName),
      selected: isSelected,
      onSelected: (selected) {
        state.filterHospitalsByCategory(categoryName);
      },
      selectedColor: AppColors.primaryDark,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.primaryDark,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.transparent : AppColors.neutralBorder,
        ),
      ),
    );
  }

  void _showNavigationModal(BuildContext context, Hospital hospital) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.navigation_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Directions to ${hospital.name}', style: AppTypography.h3),
                        Text(hospital.address, style: AppTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteStat('Distance', hospital.distance),
                    _buildRouteStat('Est. Drive', '7 mins'),
                    _buildRouteStat('Network', '100% Cashless'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Launch Apple Maps / Google Maps', style: AppTypography.button.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h3.copyWith(fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  void _showCallDialer(BuildContext context, Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Call ${hospital.name}', style: AppTypography.h3),
        content: Text('Direct hotline: ${hospital.phone}\nWould you like to place this call now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${hospital.phone}...')),
              );
            },
            child: const Text('Call Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showHospitalDetailsModal(BuildContext context, Hospital hospital) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hospital.name, style: AppTypography.h2),
              const SizedBox(height: 8),
              Text(hospital.address, style: AppTypography.bodySecondary),
              const SizedBox(height: 16),
              Text('Network Status', style: AppTypography.h3.copyWith(fontSize: 15)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.statusApprovedText, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '100% In-Network & Cashless Admission',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.statusApprovedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
