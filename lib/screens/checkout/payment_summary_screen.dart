import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mad2/providers/cart_provider.dart';
import 'package:mad2/providers/order_provider.dart';
import 'package:mad2/services/stripe_service.dart';
import 'package:provider/provider.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // 1. Get Payment Intent from Backend
      // Calculate total including delivery fee (2500 LKR) and convert to integer
      final double totalAmount = cart.total + 2500;
      final int amountInSmallestUnit = totalAmount
          .toInt(); // Backend expects integer (e.g. 6490 for 6490.00 LKR)

      debugPrint(
        "PaymentSummary: Requesting PaymentIntent for amount: $amountInSmallestUnit",
      );

      final paymentIntentData = await orderProvider.createPaymentIntent(
        amountInSmallestUnit,
      );

      if (paymentIntentData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to initialize payment: ${orderProvider.error ?? "Invalid response"}',
              ),
            ),
          );
        }
        return;
      }

      final clientSecret =
          paymentIntentData['clientSecret'] ??
          paymentIntentData['client_secret'];
      final paymentIntentId =
          paymentIntentData['paymentIntentId'] ?? paymentIntentData['id'];

      if (clientSecret == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to initialize payment: Invalid response from server',
              ),
            ),
          );
        }
        return;
      }

      debugPrint(
        "PaymentSummary: Received clientSecret (trunc): ...${clientSecret.toString().substring(clientSecret.toString().length - 4)}",
      );

      // 2. Stripe Flow: Init & Present
      debugPrint("PaymentSummary: Initializing Payment Sheet...");
      await StripeService().initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Fiorenzo',
      );
      debugPrint("PaymentSummary: Payment Sheet Initialized. Presenting...");

      debugPrint("PaymentSummary: Payment Sheet Initialized. Presenting...");
      await StripeService().presentPaymentSheet();
      debugPrint("PaymentSummary: Payment Sheet Presented. Payment Confirmed.");

      // 3. Create Order in Backend (after successful payment)
      debugPrint("PaymentSummary: Creating order in backend...");

      final responseEntries = await orderProvider.createOrder({
        'items': cart.items
            .map((i) => {'product_id': i.productId, 'quantity': i.quantity})
            .toList(),
        'total': totalAmount,
        'payment_intent_id': paymentIntentId,
        'payment_method': 'stripe',
      });

      if (responseEntries != null) {
        if (mounted) {
          debugPrint("PaymentSummary: Order created successfully.");
          Navigator.pushReplacementNamed(context, '/checkout/success');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Payment successful but order creation failed: ${orderProvider.error}',
              ),
            ),
          );
        }
      }
    } on StripeException catch (e) {
      if (mounted) {
        if (e.error.code == FailureCode.Canceled) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Payment cancelled')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: ${e.error.localizedMessage}'),
            ),
          );
        }
      }
    } catch (e, stack) {
      debugPrint("PaymentSummary: Exception $e\n$stack");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'CHECKOUT',
          style: GoogleFonts.cormorantGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                      color: Colors.grey[100],
                      child: item.product != null
                          ? Image.network(
                              item.product!.fullImageUrl,
                              fit: BoxFit.cover,
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
                      '${((double.tryParse(item.product?.price ?? '0') ?? 0) * item.quantity).toStringAsFixed(2)}',
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
            _buildRow('Subtotal', '${cart.subtotal.toStringAsFixed(2)} LKR'),
            const SizedBox(height: 8),
            _buildRow('Delivery', '2500.00 LKR'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildRow(
              'Total',
              '${(cart.total + 2500).toStringAsFixed(2)} LKR',
              isBold: true,
            ),

            const SizedBox(height: 48),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        'PAY NOW',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Secure Payment via Stripe",
                style: GoogleFonts.cormorantGaramond(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
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
