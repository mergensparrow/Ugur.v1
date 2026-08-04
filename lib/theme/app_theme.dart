import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF031B4E);
  static const navySoft = Color(0xFF102B5D);
  static const gold = Color(0xFFD8A326);
  static const goldSoft = Color(0xFFF7E8B9);
  static const background = Color(0xFFFAFBFD);
  static const surface = Colors.white;
  static const text = Color(0xFF071B48);
  static const muted = Color(0xFF69738B);
  static const border = Color(0xFFE7EAF1);
  static const success = Color(0xFF24A94B);
  static const warning = Color(0xFFC58A19);
  static const danger = Color(0xFFE42D35);
  static const blueSoft = Color(0xFFEAF4FF);
}

/// Shared width breakpoints for the phone layouts.
///
/// The approved mock-ups were drawn on a wide artboard, while Android phones
/// can report anything from roughly 320 to 500 logical pixels depending on the
/// display-density setting.  All phone widths therefore use the compact branch;
/// the roomier branch is reserved for tablets and large foldable layouts.
extension UgurResponsiveContext on BuildContext {
  double get layoutWidth => MediaQuery.sizeOf(this).width;

  bool get isCompactLayout {
    if (layoutWidth < 600) return true;
    // Mobile Safari can briefly expose a legacy ~980px web viewport before
    // the Flutter surface settles. Treat sub-1100px web viewports as phone
    // layouts so the app never falls into the oversized tablet branch.
    if (kIsWeb && layoutWidth < 1100) return true;
    return false;
  }

  bool get isVeryCompactLayout => layoutWidth < 380;

  /// Visual scale for the approved phone mock-ups.
  ///
  /// The reference screens are closest to a 430 logical-pixel artboard.
  /// Narrow Android phones therefore need slightly denser geometry, while
  /// preserving minimum tap targets in interactive widgets.
  double get phoneUiScale {
    if (!isCompactLayout) return 1;
    final width = layoutWidth;
    if (width <= 320) return .86;
    if (width <= 360) return .86 + ((width - 320) / 40) * .04;
    if (width <= 411) return .90 + ((width - 360) / 51) * .06;
    if (width <= 480) return .96 + ((width - 411) / 69) * .04;
    return 1;
  }

  double phoneMetric(double value) =>
      isCompactLayout ? value * phoneUiScale : value;
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      primary: AppColors.navy,
      secondary: AppColors.gold,
      surface: Colors.white,
      error: AppColors.danger,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
      bodySmall: TextStyle(color: AppColors.muted),
      titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.navy),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
  );
}
