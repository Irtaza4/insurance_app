import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_app/core/models/insurance_models.dart';
import 'package:insurance_app/core/state/insurance_state.dart';

void main() {
  group('InsuranceState Unit Tests', () {
    late InsuranceState state;

    setUp(() {
      state = InsuranceState();
    });

    test('Initial state loads policies, claims, and hospitals correctly', () {
      expect(state.policies.isNotEmpty, isTrue);
      expect(state.claims.isNotEmpty, isTrue);
      expect(state.hospitals.isNotEmpty, isTrue);
      expect(state.userName, 'Willie Schulist');
      expect(state.totalUpcomingPremiums, greaterThan(0));
    });

    test('Filtering policies by category works correctly', () {
      state.filterPoliciesByCategory(PolicyCategory.auto);
      expect(state.filteredPolicies.every((p) => p.category == PolicyCategory.auto), isTrue);

      state.filterPoliciesByCategory(null);
      expect(state.filteredPolicies.length, state.policies.length);
    });

    test('Filtering hospitals by category works correctly', () {
      state.filterHospitalsByCategory('Dental');
      expect(state.filteredHospitals.every((h) => h.categoryLabel.contains('Dental')), isTrue);

      state.filterHospitalsByCategory('All');
      expect(state.filteredHospitals.length, state.hospitals.length);
    });

    test('Submitting a new claim adds it to active claims and creates notification', () {
      final initialClaimCount = state.claims.length;
      final initialNotifCount = state.notifications.length;

      state.submitNewClaim(
        policyId: state.policies.first.id,
        incidentType: 'Windshield crack',
        incidentDate: '15 Aug 2026',
        location: 'Prospect Park West',
        description: 'Pebble strike on highway',
        fileNames: ['Windshield.jpg'],
      );

      expect(state.claims.length, initialClaimCount + 1);
      expect(state.claims.first.incidentType, 'Windshield crack');
      expect(state.claims.first.status, ClaimStatus.submitted);
      expect(state.notifications.length, initialNotifCount + 1);
    });

    test('Paying an upcoming premium moves it to payment history and logs notification', () {
      final upcomingPayment = state.upcomingPayments.first;
      final initialUpcomingCount = state.upcomingPayments.length;
      final initialHistoryCount = state.paymentHistory.length;

      state.payUpcomingPremium(upcomingPayment.id);

      expect(state.upcomingPayments.length, initialUpcomingCount - 1);
      expect(state.paymentHistory.length, initialHistoryCount + 1);
      expect(state.paymentHistory.first.title, upcomingPayment.title);
    });

    test('Toggling hospital map view switches view mode', () {
      expect(state.isHospitalMapView, isTrue);
      state.toggleHospitalView();
      expect(state.isHospitalMapView, isFalse);
      state.toggleHospitalView();
      expect(state.isHospitalMapView, isTrue);
    });
  });
}
