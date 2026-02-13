import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/home/screens/home_screen.dart';
import 'package:mad2/features/men/screens/men_shop_screen.dart';
import 'package:mad2/features/women/screens/women_shop_screen.dart';
import 'package:mad2/screens/cart_screen.dart';
import 'package:mad2/screens/services_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MenShopScreen(),
    const WomenShopScreen(),
    const CartScreen(),
    const ServicesScreen(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.cormorantGaramond(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: GoogleFonts.cormorantGaramond(
          fontSize: 12,
          letterSpacing: 1.0,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.male), label: 'MEN'),
          BottomNavigationBarItem(icon: Icon(Icons.female), label: 'WOMEN'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'SERVICES',
          ),
        ],
      ),
    );
  }
}
