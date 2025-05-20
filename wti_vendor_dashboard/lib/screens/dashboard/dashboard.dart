import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16.0, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back !', style: CommonFonts.h1Purple,),
                Text('Hi, Yash Khare', style: CommonFonts.bodyText4Secondary1,),

                SizedBox(height: 16,),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      GestureDetector(
                        onTap:(){
                          GoRouter.of(context).push(AppRoutes.driverBottomNavigation);
                },
                        child: DashboardCard(
                          index: 0,
                          icon: Icons.person,
                          label: 'Driver',
                        ),
                      ),
                      DashboardCard(
                        index: 1,
                        icon: Icons.directions_car_filled,
                        label: 'Vehicle',
                      ),
                      DashboardCard(
                        index: 2,
                        icon: Icons.people_rounded,
                        label: 'Booking',
                      ),
                      DashboardCard(
                        index: 3,
                        icon: Icons.cached_outlined,
                        label: 'Pair Vehicle',
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
        ));
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
      elevation: 2, // very light shadow
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
              label??'',
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