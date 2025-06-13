import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';
import 'package:wti_vendor_dashboard/screens/booking/all_booking.dart';
import 'package:wti_vendor_dashboard/screens/booking/booking_confirmation.dart';
import 'package:wti_vendor_dashboard/screens/dashboard/dashboard.dart';
import 'package:wti_vendor_dashboard/screens/driver/driver_bottom_navigation.dart';
import 'package:wti_vendor_dashboard/screens/login/login.dart';
import 'package:wti_vendor_dashboard/screens/pair_vehicle/pair_vehicle.dart';
import 'package:wti_vendor_dashboard/screens/profile/profile.dart';
import 'package:wti_vendor_dashboard/screens/vehicle/vehicle_bottom_navigation.dart';
import '../../notification_service.dart';
import '../../screens/splash_screen/splash_screen.dart';

class AppPages {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.initialPage,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => Login(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => Dashboard(),
      ),
      GoRoute(
        path: AppRoutes.driverBottomNavigation,
        builder: (context, state) => DriverBottomNavigation(),
      ),
      GoRoute(
        path: AppRoutes.vehicleBottomNavigation,
        builder: (context, state) => VehicleBottomNavigation(),
      ),
      GoRoute(
        path: AppRoutes.allBooking,
        builder: (context, state) => AllBooking(),
      ),
      GoRoute(
        path: AppRoutes.pairVehicle,
        builder: (context, state) => PairVehicle(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.confirmBooking,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          final booking = BookingConfirmation.create(data);
          return booking;
        },
      ),
    ],
  );

  static void handlePendingNavigation() {
    NotificationService().checkPendingNavigation();
  }
}
