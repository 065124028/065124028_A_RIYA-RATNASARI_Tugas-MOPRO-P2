import 'package:flutter/material.dart';

import 'pages/welcome_page.dart';
import 'pages/menu_list_page.dart';
import 'pages/menu_detail_page.dart';
import 'pages/order_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.maroon,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.maroon,
      onPrimary: Colors.white,
      surface: AppColors.cream,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 54),
            shape: buttonShape,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.maroon,
            minimumSize: const Size(0, 54),
            shape: buttonShape,
            side: BorderSide(color: AppColors.maroon.withValues(alpha: .35)),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          actionTextColor: AppColors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.maroon,
          inactiveTrackColor: AppColors.maroon.withValues(alpha: .15),
          thumbColor: AppColors.maroon,
          overlayColor: AppColors.maroon.withValues(alpha: .12),
        ),
      ),

      // Best practice: daftarkan semua route di satu tempat
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/menu': (context) => const MenuListPage(),
        '/detail': (context) => const MenuDetailPage(),
        '/pesan': (context) => const OrderPage(),
      },
    );
  }
}