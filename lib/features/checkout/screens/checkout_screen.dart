import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/cart/providers/cart_provider.dart';
import 'package:mad2/features/orders/providers/order_provider.dart';
import 'package:mad2/providers/location_provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  @override
  void dispose() {
    _isProcessing.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    _isProcessing.value = true;
    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      // 1. Validation
      if (cart.items.isEmpty) {
        throw Exception("Cart is empty");
      }

      // Optional: Check if location is set
      // if (locationProvider.currentAddress == null) {
      //   throw Exception("Please select a delivery location");
      // }

      final double totalAmount = cart.total + 2500;

      // 2. Call Backend
      debugPrint("Checkout: Placing COD Order...");
      final responseEntries = await orderProvider.createOrder({
        'items': cart.items
            .map((i) => {'product_id': i.productId, 'quantity': i.quantity})
            .toList(),
        'total': totalAmount,
        'total_amount': totalAmount,
        'payment_method': 'cod',
        'status': 'pending',
        'payment_intent_id': null,
      });

      if (responseEntries != null && mounted) {
        // 3. Success
        cart.clear();
        Navigator.pushReplacementNamed(context, '/order-confirmation');
      } else {
        throw Exception(
          orderProvider.error ?? 'Order placement failed. Please try again.',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll("Exception:", "")}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        _isProcessing.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Calculate totals once
    final subtotal = cart.subtotal;
    final total = subtotal + 2500;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'CHECKOUT',
          style: GoogleFonts.cormorantGaramond(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ORDER SUMMARY',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            // Items List
            ...cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 80,
                      color: Theme.of(context).colorScheme.surface,
                      child: item.product != null
                          ? CachedNetworkImage(
                              imageUrl: item.product!.fullImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image, size: 24),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product?.name ?? '',
                            style: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ((double.tryParse(item.product?.price ?? '0') ?? 0) *
                              item.quantity)
                          .toStringAsFixed(2),
                      style: GoogleFonts.cormorantGaramond(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 48),
            // Totals
            _buildRow('Subtotal', '${subtotal.toStringAsFixed(2)} LKR'),
            const SizedBox(height: 8),
            const _PaymentRow(label: 'Delivery', value: '2500.00 LKR'),
            const SizedBox(height: 24),

            // Location Section
            Text(
              'DELIVERY LOCATION',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            const _LocationSection(),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildRow('Total', '${total.toStringAsFixed(2)} LKR', isBold: true),

            const SizedBox(height: 48),

            // Place Order Button
            ValueListenableBuilder<bool>(
              valueListenable: _isProcessing,
              builder: (context, isProcessing, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: isProcessing ? null : _placeOrder,
                    child: isProcessing
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            'PLACE ORDER',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Pay on Delivery within 2 weeks",
                style: GoogleFonts.cormorantGaramond(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return _PaymentRow(label: label, value: value, isBold: isBold);
  }
}

// Extracted Const Widget for Rows
class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.cormorantGaramond(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.cormorantGaramond(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Extracted Location Section
class _LocationSection extends StatelessWidget {
  const _LocationSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (locationProvider.isLoading)
                      const Text(
                        'Getting location...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else if (locationProvider.error != null)
                      Text(
                        locationProvider.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    else if (locationProvider.currentAddress != null)
                      Text(
                        locationProvider.currentAddress!,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      Text(
                        'No location set',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              if (locationProvider.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              else
                TextButton(
                  onPressed: () => locationProvider.getCurrentLocation(),
                  child: Text(
                    'GENERATE LOCATION',
                    style: GoogleFonts.cormorantGaramond(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
