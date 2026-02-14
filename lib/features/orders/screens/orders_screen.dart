import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/orders/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/OTHER/Order.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey[900]),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.6),
                  ), // Overlay
                  Center(
                    child: Text(
                      'MY ORDERS',
                      style: GoogleFonts.cormorantGaramond(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }

                if (provider.orders.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You haven't placed any orders yet.",
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: const Text("START SHOPPING"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final order = provider.orders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ORDER #${order.id}',
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM d, y',
                                    ).format(order.createdAt),
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.status == 'pending'
                                      ? 'PENDING (PAY ON DELIVERY)'
                                      : order.status.toUpperCase(),
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          // Order Items Preview
                          ...order.items
                              .take(2)
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item.quantity}x ${item.product?.name ?? 'Product #${item.productId}'}',
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        (item.unitPrice * item.quantity)
                                            .toStringAsFixed(0),
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          if (order.items.length > 2)
                            Text(
                              '+ ${order.items.length - 2} more items...',
                              style: GoogleFonts.cormorantGaramond(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),

                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style: GoogleFonts.cormorantGaramond(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'LKR ${order.totalAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }, childCount: provider.orders.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
