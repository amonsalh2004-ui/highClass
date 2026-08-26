import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color palette matching the "هاي كلاس" (Hi Class) brand,
/// using the exact approved hex values.
class AppColors {
  static const Color maroon = Color(0xFF6B1D30); // primary maroon
  static const Color maroonDark = Color(0xFF651F2F); // deep maroon (headers)
  static const Color maroonAlt = Color(0xFF742435); // secondary maroon accent
  static const Color bronze = Color(0xFFA66545); // warm bronze accent
  static const Color gold = Color(0xFFF1C455); // gold (buttons/highlights)
  static const Color goldLight = Color(0xFFF1C455);
  static const Color background = Color(0xFFF6F0F0); // warm off-white bg
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF3A2A2E);
  static const Color textMuted = Color(0xFF8A7B7E);
  static const Color success = Color(0xFF2E9B4F);
  static const Color successBg = Color(0xFFE3F5E8);
  static const Color warning = Color(0xFFF1C455);
  static const Color warningBg = Color(0xFFFBF0DA);
  static const Color danger = Color(0xFF651F2F);
  static const Color grey = Color(0xFF9A9A9A);
  static const Color greyBg = Color(0xFFF0EDE8);
}

class AppTheme {
  /// Tajawal Bold — used for most UI text (labels, buttons, body-strong).
  static TextStyle tajawalBold({double fontSize = 16, Color? color}) =>
      GoogleFonts.tajawal(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textDark,
      );

  /// Tajawal ExtraBold — used for headings/titles/big numbers.
  static TextStyle tajawalExtraBold({double fontSize = 20, Color? color}) =>
      GoogleFonts.tajawal(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textDark,
      );

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.maroon,
        primary: AppColors.maroon,
        secondary: AppColors.gold,
        surface: AppColors.background,
      ),
      fontFamily: GoogleFonts.tajawal().fontFamily,
      textTheme: GoogleFonts.tajawalTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ).copyWith(
        // Default body/label weight bumped to Bold per brand spec.
        bodyMedium: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.tajawal(fontWeight: FontWeight.w800),
        titleMedium: GoogleFonts.tajawal(fontWeight: FontWeight.w800),
        headlineSmall: GoogleFonts.tajawal(fontWeight: FontWeight.w800),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.maroonDark,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: tajawalExtraBold(fontSize: 20, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.maroonDark,
          minimumSize: const Size.fromHeight(56),
          textStyle: tajawalExtraBold(fontSize: 18, color: AppColors.maroonDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE7DFD6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE7DFD6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }
}
