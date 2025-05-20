import 'package:go_router/go_router.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';
import 'package:wti_vendor_dashboard/screens/dashboard/dashboard.dart';
import 'package:wti_vendor_dashboard/screens/driver/driver_bottom_navigation.dart';
import 'package:wti_vendor_dashboard/screens/login/login.dart';
import '../../main.dart';
import '../../screens/splash_screen/splash_screen.dart';

class AppPages{
   static final GoRouter router = GoRouter(
      navigatorKey: navigatorKey,
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


      ]
   );
}