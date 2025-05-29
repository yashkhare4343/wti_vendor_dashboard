import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/main.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';
import 'package:wti_vendor_dashboard/screens/driver/driver_bottom_navigation.dart';
import 'package:wti_vendor_dashboard/utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Handle menu item selection
  void _handleMenuSelection(String item, BuildContext context) {
    switch (item) {
      case 'profile':
        break;
      case 'logout':
        break;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (Platform.isIOS) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear all SharedPreferences data
      } else {
        await secureStorage.deleteAll(); // Clear all FlutterSecureStorage data
      }
      // Navigate to login screen
      GoRouter.of(context).go(AppRoutes.loginScreen);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Dashboard",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: UserIconCircle(
              size: 40,
              backgroundColor: Colors.blueAccent,
              iconColor: Colors.white,
            ),
            onSelected: (String item) => _handleMenuSelection(item, context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                onTap: (){
                  GoRouter.of(context).push(AppRoutes.profile);
                },
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                onTap: (){
                  logout(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome Back !', style: CommonFonts.h1Purple),
              Text('Hi, Yash Khare', style: CommonFonts.bodyText4Secondary1),
              SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.driverBottomNavigation);
                      },
                      child: DashboardCard(
                        index: 0,
                        icon: Icons.person,
                        label: 'Driver',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.vehicleBottomNavigation);
                      },
                      child: DashboardCard(
                        index: 1,
                        icon: Icons.directions_car_filled,
                        label: 'Vehicle',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.allBooking);
                      },
                      child: DashboardCard(
                        index: 2,
                        icon: Icons.people_rounded,
                        label: 'Booking',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.pairVehicle);
                      },
                      child: DashboardCard(
                        index: 3,
                        icon: Icons.cached_outlined,
                        label: 'Pair Vehicle',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final int index;
  final IconData? icon;
  final String? label;
  const DashboardCard({super.key, required this.index, this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              label ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UserIconCircle extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const UserIconCircle({
    super.key,
    this.size = 48.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: Icon(
        Icons.person,
        color: iconColor,
        size: size * 0.6,
      ),
    );
  }
}
