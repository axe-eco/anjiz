import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// ثيم أنجز الداكن — Cosmic Aurora
ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.spaceDeep,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.uvCore,
    secondary: AppColors.mintCore,
    surface: AppColors.spaceCard,
    error: AppColors.magCore,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.spaceDeep,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.cairo(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: AppColors.uvPearl,
    ),
    iconTheme: const IconThemeData(color: AppColors.uvMist),
  ),
  cardTheme: CardThemeData(
    color: AppColors.spaceCard,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.uvCore,
    foregroundColor: Colors.white,
    elevation: 8,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.spaceCard,
    hintStyle: GoogleFonts.cairo(
      color: AppColors.uvMist.withValues(alpha: 0.5),
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.spaceLift.withValues(alpha: 0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.uvCore, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.uvCore,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.uvBright,
      textStyle: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.spaceDeep,
    selectedItemColor: AppColors.uvCore,
    unselectedItemColor: AppColors.uvMist,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.mintCore;
      }
      return AppColors.spaceLift;
    }),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.spaceLift.withValues(alpha: 0.5),
    thickness: 1,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.spaceCard,
    contentTextStyle: GoogleFonts.cairo(color: AppColors.uvPearl),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  ),
);
