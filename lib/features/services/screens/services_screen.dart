import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SERVICES',
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildServiceTile(
            context,
            icon: Icons.person_outline,
            title: 'My Account',
            onTap: () => Navigator.pushNamed(context, '/account'),
          ),
          _buildServiceTile(
            context,
            icon: Icons.star_outline,
            title: 'AS SEEN ON',
            onTap: () => Navigator.pushNamed(context, '/celebrities'),
          ),
          _buildServiceTile(
            context,
            icon: Icons.local_shipping_outlined,
            title: 'Orders & Returns',
            onTap: () {}, // TODO: Implement Orders Screen
          ),
          _buildServiceTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Contact',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        title: Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
