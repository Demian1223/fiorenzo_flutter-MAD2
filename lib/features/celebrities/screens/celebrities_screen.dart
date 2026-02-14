import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/celebrities/models/celebrity.dart';
import 'package:mad2/features/celebrities/screens/celebrity_detail_screen.dart';

class CelebritiesScreen extends StatefulWidget {
  const CelebritiesScreen({super.key});

  @override
  State<CelebritiesScreen> createState() => _CelebritiesScreenState();
}

class _CelebritiesScreenState extends State<CelebritiesScreen> {
  List<Celebrity> _celebrities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCelebrities();
  }

  Future<void> _loadCelebrities() async {
    try {
      // Load JSON from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/celebrities.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        _celebrities = jsonList
            .map((json) => Celebrity.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading celebrities: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AS SEEN ON',
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _celebrities.isEmpty
          ? const Center(child: Text("No celebrities found."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _celebrities.length,
              itemBuilder: (context, index) {
                final celeb = _celebrities[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CelebrityDetailScreen(celebrity: celeb),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 24), // More spacing
                    color: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                    ),
                    child: Column(
                      // Changed to Column for big vertical cards
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Big Image
                        Hero(
                          tag: 'celeb-${celeb.id}',
                          child: Container(
                            width: double.infinity,
                            height: 400, // MUCH TALLER IMAGE
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(celeb.image),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                onError: (_, __) {},
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0), // More padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                celeb.name.toUpperCase(),
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 24, // Bigger font
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                celeb.role,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "READ FULL PROFILE →",
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
