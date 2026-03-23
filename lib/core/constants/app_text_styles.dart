import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// أنماط النصوص — تستخدم خط Cairo العربي
class AppTextStyles {
  AppTextStyles._();

  /// خط Cairo الأساسي
  static TextStyle _cairo({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.uvPearl,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  // ── العناوين ──
  static TextStyle get heading1 => _cairo(size: 28, weight: FontWeight.w900);
  static TextStyle get heading2 => _cairo(size: 22, weight: FontWeight.w800);
  static TextStyle get heading3 => _cairo(size: 18, weight: FontWeight.w700);

  // ── النص الأساسي ──
  static TextStyle get bodyLarge  => _cairo(size: 16, weight: FontWeight.w500);
  static TextStyle get bodyMedium => _cairo(size: 14, weight: FontWeight.w400);
  static TextStyle get bodySmall  => _cairo(size: 12, weight: FontWeight.w400, color: AppColors.uvMist);

  // ── النص المساعد ──
  static TextStyle get caption => _cairo(size: 11, weight: FontWeight.w400, color: AppColors.uvMist);
  static TextStyle get label   => _cairo(size: 13, weight: FontWeight.w700, color: AppColors.uvBright);

  // ── الأزرار ──
  static TextStyle get button => _cairo(size: 15, weight: FontWeight.w800);

  // ── الأرقام ──
  static TextStyle get number => _cairo(size: 32, weight: FontWeight.w900, color: AppColors.mintNeon);
  static TextStyle get percentage => _cairo(size: 20, weight: FontWeight.w800, color: AppColors.uvBright);
}
