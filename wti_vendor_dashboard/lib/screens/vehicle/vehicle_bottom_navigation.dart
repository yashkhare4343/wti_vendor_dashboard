import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wti_vendor_dashboard/screens/driver/add_driver.dart';
import 'package:wti_vendor_dashboard/screens/driver/all_driver.dart';
import 'package:wti_vendor_dashboard/screens/vehicle/add_vehicle.dart';
import 'package:wti_vendor_dashboard/screens/vehicle/all_vehicle.dart';
import '../../utility/constants/colors/app_colors.dart';


class VehicleBottomNavigation extends StatefulWidget {
  final int initialIndex;

  const VehicleBottomNavigation({super.key, this.initialIndex = 0});

  @override
  _VehicleBottomNavigationState createState() => _VehicleBottomNavigationState();
}

class _VehicleBottomNavigationState extends State<VehicleBottomNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize with the passed index
  }

  final List<Widget> _pages = [
    AllVehicle(),
    AddVehicle(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.blueAccent,
          unselectedItemColor: Colors.grey,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.directions_car_filled), label: 'All Vehicle'),
            BottomNavigationBarItem(icon: Icon(Icons.add_to_drive), label: 'Add Vehicle'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        )
    );
  }
}
