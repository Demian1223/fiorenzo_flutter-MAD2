import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/auth/providers/auth_provider.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/providers/cart_provider.dart';
import 'package:mad2/providers/order_provider.dart';
import 'package:mad2/screens/cart_screen.dart';
import 'package:mad2/screens/checkout/payment_success_screen.dart';
import 'package:mad2/screens/checkout/payment_summary_screen.dart';
import 'package:mad2/screens/main_screen.dart';
import 'package:mad2/features/auth/screens/login_screen.dart';
import 'package:mad2/features/account/screens/my_account_screen.dart';
import 'package:mad2/screens/orders_screen.dart';
import 'package:mad2/features/auth/screens/auth_gate.dart';
import 'package:provider/provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Replace with your actual Stripe Publishable Key
  Stripe.publishableKey =
      'pk_test_51Sxh0WIIx8T5NhTFQktGnGnO53WVoeKgsniy4eyg8aWYuLpp7ZPrFglefuznTj9xQDNm1FMrApe5Biq3TzQ4wNIk00bC9CmBEY';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Fiorenzo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            secondary: Color(0xFF8b0000), // Deep Red
            surface: Colors.white,
            background: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: GoogleFonts.cormorantGaramondTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.black, displayColor: Colors.black),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: GoogleFonts.cormorantGaramond(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/home': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/account': (context) => const MyAccountScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout/summary': (context) => const PaymentSummaryScreen(),
          '/checkout/success': (context) => const PaymentSuccessScreen(),
          '/orders': (context) => const OrdersScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/product-detail') {
            final args = settings.arguments;
            // Ensure we pass the product model correctly
            // If args is ProductModel, use it directly
            // If args is int (id), we might need to fetch it (not implemented here yet)
            // For now assuming we pass the full ProductModel or handle it

            // Actually, my ProductDetailScreen expects a 'product' argument of type ProductModel
            // My recent edit to products_screen.dart passed the 'product' model.
            // So:
            if (args != null) {
              // We need to import ProductModel to cast, or just pass it dynamic
              // Let's assume args is ProductModel
              // But wait, I changed ProductDetailScreen to take 'product' in constructor
              // Routes work best with named arguments or a wrapper
              // Let's use MaterialPageRoute builder logic
            }

            // Dynamic route handling usually difficult with strict typing without casting
            // Reverting to using named router with arguments extraction inside the widget
            // OR using the simple push from ProductCard which I implemented:
            // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)))

            // So I don't strictly need onGenerateRoute for product detail if I use direct pushes,
            // BUT if I want deep linking or named routes I do.
            // I'll leave onGenerateRoute empty for now and rely on the direct push
            // implemented in ProductCard.
            return null;
          }
          return null;
        },
      ),
    );
  }
}
