import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[50],
                ),
                child: const Icon(Icons.check, size: 50, color: Colors.green),
              ),
              const SizedBox(height: 32),
              Text(
                'PAYMENT SUCCESSFUL',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for your purchase.\nYour order has been confirmed.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/orders',
                          (route) => route.isFirst,
                        );
                      },
                      child: Text(
                        'VIEW ORDERS',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: Text(
                        'SHOP MORE',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
