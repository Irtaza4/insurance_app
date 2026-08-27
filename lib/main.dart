import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/state/insurance_state.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/claims/claims_screen.dart';
import 'features/home/home_screen.dart';
import 'features/hospitals/hospitals_screen.dart';
import 'features/payments/payments_screen.dart';
import 'features/policies/policy_detail_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/rewards/rewards_screen.dart';
import 'features/teleconsult/teleconsult_screen.dart';
import 'shared/widgets/custom_bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatefulWidget {
  const InsuranceApp({super.key});

  @override
  State<InsuranceApp> createState() => _InsuranceAppState();
}

class _InsuranceAppState extends State<InsuranceApp> {
  final InsuranceState _state = InsuranceState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _state,
      builder: (context, child) {
        return MaterialApp(
          title: 'Antigravity Insurance',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: MainAppShell(state: _state),
        );
      },
    );
  }
}

class MainAppShell extends StatefulWidget {
  final InsuranceState state;

  const MainAppShell({
    super.key,
    required this.state,
  });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.state.currentNavIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(
            state: widget.state,
            onNavigateToClaims: () => widget.state.setNavIndex(1),
            onNavigateToHospitals: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HospitalsScreen(
                    state: widget.state,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            onNavigateToPayments: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentsScreen(state: widget.state)),
              );
            },
            onNavigateToTeleconsult: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeleconsultScreen(state: widget.state)),
              );
            },
            onSelectPolicy: (policy) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PolicyDetailScreen(policy: policy, state: widget.state),
                ),
              );
            },
          ),
          ClaimsScreen(state: widget.state),
          RewardsScreen(state: widget.state),
          ProfileScreen(state: widget.state),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => widget.state.setNavIndex(index),
      ),
    );
  }
}
