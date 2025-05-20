import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wti_vendor_dashboard/screens/driver/add_driver.dart';
import 'package:wti_vendor_dashboard/screens/driver/all_driver.dart';
import '../../utility/constants/colors/app_colors.dart';


class DriverBottomNavigation extends StatefulWidget {
  final int initialIndex;

  const DriverBottomNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _DriverBottomNavigationState createState() => _DriverBottomNavigationState();
}

class _DriverBottomNavigationState extends State<DriverBottomNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize with the passed index
  }

  final List<Widget> _pages = [
    AllDriver(),
    AddDriver(),
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
            BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'All Drivers'),
            BottomNavigationBarItem(icon: Icon(Icons.person_add_rounded), label: 'ADD Driver'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        )
    );
  }
}
