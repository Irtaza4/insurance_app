import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_app/main.dart';
import 'package:insurance_app/shared/widgets/service_icon_button.dart';

void main() {
  testWidgets('InsuranceApp renders SplashScreen, transitions to MainShell, switches animated tabs, and tests Payments button layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844); // Standard modern mobile viewport
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const InsuranceApp(showSplash: true));
    await tester.pump(const Duration(milliseconds: 700));

    // 1. Verify Splash Screen
    expect(find.text('INSURANCE'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap Get Started to enter MainShell
    await tester.tap(find.text('Get Started'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 700));

    // 2. Verify Home Screen
    expect(find.text('Welcome Back'), findsWidgets);
    expect(find.text('Willie Schulist'), findsWidgets);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Payment'), findsWidgets);
    expect(find.text('Hospitals'), findsWidgets);

    // 3. Verify Bottom Navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Claims'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 4. Test Tab Switching with Animations
    // Navigate to Claims tab
    await tester.tap(find.text('Claims'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Your Claims'), findsOneWidget);

    // Navigate to Rewards tab
    await tester.tap(find.text('Rewards'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Rewards & Benefits'), findsOneWidget);
    expect(find.text('3,450'), findsOneWidget);

    // Navigate to More / Profile tab
    await tester.tap(find.text('More'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Profile & Settings'), findsOneWidget);

    // Return to Home tab
    await tester.tap(find.text('Home'));
    await tester.pump(const Duration(milliseconds: 700));

    // 5. Test Payments Screen button layout (Pay now / Manage auto-pay without overflow)
    final paymentButton = find.widgetWithText(ServiceIconButton, 'Payment');
    expect(paymentButton, findsOneWidget);
    await tester.tap(paymentButton);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Payments & Billing'), findsOneWidget);
    expect(find.text('Pay now'), findsWidgets);
    expect(find.text('Manage auto-pay'), findsOneWidget);

    // Pop back to Home
    Navigator.of(tester.element(find.text('Payments & Billing'))).pop();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // 6. Open Hospitals from Services grid
    final hospitalButton = find.widgetWithText(ServiceIconButton, 'Hospitals');
    expect(hospitalButton, findsOneWidget);
    await tester.tap(hospitalButton);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Harmony General Hospital'), findsWidgets);
    expect(find.text('Direction'), findsWidgets);
  });
}
