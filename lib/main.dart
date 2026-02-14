import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/auth/providers/auth_provider.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/features/cart/providers/cart_provider.dart';
import 'package:mad2/features/orders/providers/order_provider.dart';
import 'package:mad2/providers/connectivity_provider.dart';
import 'package:mad2/providers/location_provider.dart';
import 'package:mad2/providers/device_provider.dart';
import 'package:mad2/features/cart/screens/cart_screen.dart';
import 'package:mad2/features/checkout/screens/order_confirmation_screen.dart';
import 'package:mad2/features/checkout/screens/checkout_screen.dart';
import 'package:mad2/features/shop/screens/main_screen.dart';
import 'package:mad2/features/auth/screens/login_screen.dart';
import 'package:mad2/features/account/screens/my_account_screen.dart';
import 'package:mad2/features/orders/screens/orders_screen.dart';
import 'package:mad2/features/celebrities/screens/celebrities_screen.dart';
import 'package:mad2/features/auth/screens/auth_gate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: MaterialApp(
        title: 'Fiorenzo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            secondary: Color(0xFF8b0000), // Deep Red
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: GoogleFonts.cormorantGaramondTextTheme().apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
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
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Color(0xFF8b0000), // Deep Red
            surface: const Color(0xFF1E1E1E), // Dark Grey for cards
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: Colors.white, // White text on dark
          ),
          textTheme: GoogleFonts.cormorantGaramondTextTheme(
            ThemeData.dark().textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/home': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/account': (context) => const MyAccountScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order-confirmation': (context) => const OrderConfirmationScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/celebrities': (context) => const CelebritiesScreen(),
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
