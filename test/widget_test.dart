import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_app/main.dart';
import 'package:insurance_app/shared/widgets/service_icon_button.dart';

void main() {
  testWidgets('InsuranceApp renders Home, Rewards, Claims, and navigates to Hospitals', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const InsuranceApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify User greeting and name from reference design
    expect(find.text('Welcome Back'), findsWidgets);
    expect(find.text('Willie Schulist'), findsWidgets);

    // Verify services
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Payment'), findsWidgets);
    expect(find.text('Hospitals'), findsWidgets);

    // Verify Bottom Navigation items matching Image 1
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Claims'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // Navigate to Claims tab
    await tester.tap(find.text('Claims'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Your Claims'), findsOneWidget);

    // Navigate to Rewards tab (dedicated screen)
    await tester.tap(find.text('Rewards'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Rewards & Benefits'), findsOneWidget);
    expect(find.text('3,450'), findsOneWidget);

    // Navigate to More / Profile tab
    await tester.tap(find.text('More'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Profile & Settings'), findsOneWidget);

    // Return to Home tab
    await tester.tap(find.text('Home'));
    await tester.pump(const Duration(milliseconds: 100));

    // Open Hospitals from Services grid
    final hospitalButton = find.widgetWithText(ServiceIconButton, 'Hospitals');
    expect(hospitalButton, findsOneWidget);
    await tester.tap(hospitalButton);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Harmony General Hospital'), findsWidgets);
    expect(find.text('Direction'), findsWidgets);
  });
}
