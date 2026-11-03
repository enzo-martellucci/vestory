import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final textTheme = GoogleFonts.dmSansTextTheme().apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);
    final buttonTextStyle = GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700);
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        primary: AppColors.indigo,
        surface: AppColors.vanilla,
        onSurface: AppColors.ink,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.vanilla,
      textTheme: textTheme.copyWith(
        displaySmall: GoogleFonts.bricolageGrotesque(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: AppColors.indigo,
        ),
        headlineMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: AppColors.indigo,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.muted),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w600),
        enabledBorder: _fieldBorder(AppColors.fieldBorder),
        focusedBorder: _fieldBorder(AppColors.indigo),
        errorBorder: _fieldBorder(AppColors.error),
        focusedErrorBorder: _fieldBorder(AppColors.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white,
          textStyle: buttonTextStyle,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.fieldBorder, width: 1.5),
          textStyle: buttonTextStyle,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.indigo,
          textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.muted,
          selectedBackgroundColor: AppColors.indigo,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: AppColors.cardBorder),
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color, width: 1.5),
  );
}
