import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();

  factory StripeService() {
    return _instance;
  }

  StripeService._internal();

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      debugPrint("StripeService: calling initPaymentSheet");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Colors.black),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Stripe Init Error: $e");
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      debugPrint("Stripe Present Error: $e");
      rethrow;
    }
  }
}
