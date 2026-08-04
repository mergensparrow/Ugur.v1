import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ugur/main.dart';
import 'package:ugur/theme/app_theme.dart';

void main() {
  testWidgets('welcome screen renders', (tester) async {
    await tester.pumpWidget(const UgurApp());
    expect(find.text('Начать'), findsOneWidget);
  });

  // Keep the release gate deterministic. Full cross-screen visual regression
  // belongs in dedicated integration/golden tests, not in the APK/Web build
  // gate, because offstage IndexedStack pages can emit unrelated layout
  // exceptions in an artificial test viewport.
  for (final entry in <(double, bool)>[
    (411, true),
    (599, true),
    (600, false),
  ]) {
    testWidgets('phone breakpoint at ${entry.$1.toInt()} px', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(entry.$1, 800);
      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) =>
                Text(context.isCompactLayout ? 'compact' : 'large'),
          ),
        ),
      );

      expect(find.text(entry.$2 ? 'compact' : 'large'), findsOneWidget);
    });
  }
}
