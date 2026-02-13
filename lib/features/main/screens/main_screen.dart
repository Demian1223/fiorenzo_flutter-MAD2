import 'package:flutter/material.dart';
import 'package:mad2/core/constants/app_colors.dart';
import 'package:mad2/features/account/screens/my_account_screen.dart';
import 'package:mad2/features/home/screens/home_screen.dart';
import 'package:mad2/features/men/screens/men_screen.dart';
import 'package:mad2/features/services/screens/services_screen.dart';
import 'package:mad2/features/women/screens/women_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MenScreen(),
    const WomenScreen(),
    const ServicesScreen(),
    const MyAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.primary, // Black background
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_outlined),
              activeIcon: Icon(Icons.man),
              label: 'Men',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.woman_outlined),
              activeIcon: Icon(Icons.woman),
              label: 'Women',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.design_services_outlined),
              activeIcon: Icon(Icons.design_services),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'MyAcc',
            ),
          ],
        ),
      ),
    );
  }
}
