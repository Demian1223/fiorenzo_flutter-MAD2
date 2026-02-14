import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/celebrities/models/celebrity.dart';

class CelebrityDetailScreen extends StatelessWidget {
  final Celebrity celebrity;

  const CelebrityDetailScreen({super.key, required this.celebrity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          celebrity.name.toUpperCase(),
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Area
            SizedBox(
              width: double.infinity,
              height: 400, // Taller for celebs
              child: Hero(
                tag: 'celeb-${celebrity.id}',
                child: Image.asset(
                  celebrity.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.star, size: 64, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    celebrity.role.toUpperCase(),
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    '"${celebrity.philosophy}"',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle('ABOUT'),
                  const SizedBox(height: 8),
                  Text(
                    celebrity.bio,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('SEEN AT'),
                  const SizedBox(height: 8),
                  Text(
                    celebrity.experience, // Mapped locally
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, width: 40, color: Colors.black),
      ],
    );
  }
}
