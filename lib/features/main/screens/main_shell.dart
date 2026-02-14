import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/home/screens/home_screen.dart';
import 'package:mad2/features/men/screens/men_shop_screen.dart';
import 'package:mad2/features/women/screens/women_shop_screen.dart';
import 'package:mad2/features/cart/screens/cart_screen.dart';
import 'package:mad2/screens/services_screen.dart';
import 'package:mad2/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WomenShopScreen(),
    const MenShopScreen(),
    const CartScreen(),
    const ServicesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          unselectedLabelStyle: GoogleFonts.cormorantGaramond(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.woman_outlined),
              activeIcon: Icon(Icons.woman),
              label: 'Women',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_outlined),
              activeIcon: Icon(Icons.man),
              label: 'Men',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Services',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            if (auth.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () => auth.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('LOGOUT'),
              ),
          ],
        ),
      ),
    );
  }
}
