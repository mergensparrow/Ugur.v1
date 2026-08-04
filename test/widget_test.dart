import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ugur/main.dart';
import 'package:ugur/screens/main_shell.dart';
import 'package:ugur/theme/app_theme.dart';

void main() {
  testWidgets('welcome screen renders', (tester) async {
    await tester.pumpWidget(const UgurApp());
    expect(find.text('Начать'), findsOneWidget);
  });

  for (final width in <double>[320, 360, 411, 480]) {
    testWidgets('main shell has no layout exception at ${width.toInt()} px', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 720);
      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const MainShell(),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Уведомления'), findsWidgets);

      // Render the lower Home module where compact-card overflows previously
      // appeared, then visit every main tab at the same device width.
      await tester.drag(find.byType(ListView).first, const Offset(0, -520));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      for (final label in <String>[
        'Избранное',
        'Запросы',
        'Уведомления',
        'Профиль',
      ]) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }

  for (final entry in <(double, bool)>[(411, true), (599, true), (600, false)]) {
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
            builder: (context) => Text(context.isCompactLayout ? 'compact' : 'large'),
          ),
        ),
      );

      expect(find.text(entry.$2 ? 'compact' : 'large'), findsOneWidget);
    });
  }
}
