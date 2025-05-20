import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      body: SafeArea(child: Center(
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
                  // Button
                  PrimaryButton(text: 'Get Started', onPressed: (){
                    GoRouter.of(context).push(AppRoutes.loginScreen);
                  })
                ],
              ),
            ),
          )
        ),
      )),

    );
  }
}
