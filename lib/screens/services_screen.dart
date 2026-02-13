import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'SERVICES',
          style: GoogleFonts.cormorantGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          _buildServiceTile(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            subtitle: 'Discover our story, mission, and passion.',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildServiceTile(
            context,
            icon: Icons.balance,
            title: 'Ethics & Values',
            subtitle: 'Learn about sustainability and integrity.',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildServiceTile(
            context,
            icon: Icons.help_outline,
            title: 'FAQ',
            subtitle: 'Answers to common questions from our clients.',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildServiceTile(
            context,
            icon: Icons.person_outline,
            title: 'My Profile',
            subtitle: 'Manage your account details.',
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          const SizedBox(height: 16),
          _buildServiceTile(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'View your order history.',
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
