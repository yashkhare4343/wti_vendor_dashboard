import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/primary_button.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';
import 'package:wti_vendor_dashboard/utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<String?> readData(String key) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<void> writeData(String key, String value) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await secureStorage.write(key: key, value: value);
    }
  }

  Future<void> _checkSessionAndNavigate() async {
    // Add a small delay for better UX
    await Future.delayed(Duration(seconds: 2));

    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    try {
      // Check for token in storage
      final token = await readData('token');

      // Check if widget is still mounted before navigating
      if (!mounted) return;

      // Navigate based on token presence
      if (token != null && token.isNotEmpty) {
        GoRouter.of(context).go(AppRoutes.dashboard);
      } else {
        GoRouter.of(context).go(AppRoutes.loginScreen);
      }
    } catch (error) {
      // Check if widget is still mounted before showing SnackBar
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking session: $error')),
      );
      // Navigate to login screen as fallback
      GoRouter.of(context).go(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 320,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 32),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0.6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/wti_logo.png', // Your splash screen image
                      width: 60,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    // Heading
                    const Text(
                      'Welcome to WTI Vendor Dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtext
                    Text(
                      'Manage your rides, earnings, and bookings seamlessly with the Vendor Dashboard app',
                      textAlign: TextAlign.center,
                      style: CommonFonts.bodyText1,
                    ),
                    const SizedBox(height: 16),
                    // Button (optional, as auto-navigation is handled)
                    PrimaryButton(
                      text: 'Get Started',
                      onPressed: () {
                        if (mounted) {
                          _checkSessionAndNavigate();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}