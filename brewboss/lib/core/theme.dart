import 'package:flutter/material.dart';

/// Palette of the SRS mock-ups: charcoal on white with a single red accent.
class AppColors {
  static const ink = Color(0xFF333333);
  static const text = Color(0xFF1F1F1F);
  static const muted = Color(0xFF7A7A7A);
  static const border = Color(0xFFBDBDBD);
  static const divider = Color(0xFFCFCFCF);
  static const fill = Color(0xFFEFEFEF);
  static const busy = Color(0xFFD6D6D6);
  static const disabled = Color(0xFFB9B9B9);
  static const red = Color(0xFFC62828);
}

const _radius = 10.0;

ThemeData buildTheme() {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius));
  const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  const minSize = Size(48, 52);

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSans',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: Colors.white,
      secondary: AppColors.ink,
      error: AppColors.red,
      surface: Colors.white,
      onSurface: AppColors.text,
      outline: AppColors.border,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontFamily: 'NotoSans', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text),
      shape: Border(bottom: BorderSide(color: AppColors.divider)),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.ink),
      errorBorder: border(AppColors.red),
      focusedErrorBorder: border(AppColors.red),
      hintStyle: const TextStyle(color: AppColors.muted),
      errorMaxLines: 3,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: Colors.white,
        minimumSize: minSize,
        shape: buttonShape,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.ink),
        minimumSize: minSize,
        shape: buttonShape,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.text,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.ink : AppColors.disabled),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.ink,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.text,
      unselectedLabelColor: AppColors.muted,
      indicatorColor: AppColors.ink,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w700, fontSize: 15),
      unselectedLabelStyle: TextStyle(fontFamily: 'NotoSans', fontSize: 15),
      dividerColor: AppColors.divider,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, backgroundColor: AppColors.ink),
  );
}
