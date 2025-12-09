import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/app_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 18,
             fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final cartItems = provider.cart;
          final equipmentList = provider.equipment;

          if (cartItems.isEmpty) {
            return const Center(child: Text("Keranjang kosong", style: TextStyle(fontFamily: 'Plus Jakarta Sans'),));
          }

          double subtotal = 0;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  separatorBuilder: (ctx, idx) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final equipment = equipmentList.firstWhere(
                      (e) => e.id == item.equipmentId,
                      orElse: () => equipmentList[0], // Fallback shouldn't happen
                    );

                    final duration = item.endDate.difference(item.startDate).inDays + 1;
                    final totalPrice = equipment.pricePerDay * duration * item.quantity;
                    subtotal += totalPrice;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              equipment.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        equipment.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                           fontFamily: 'Plus Jakarta Sans',
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        provider.removeCartItem(item.id);
                                      },
                                      child: const Icon(Icons.delete_outline, color: Colors.red),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Durasi: ${DateFormat('dd MMM').format(item.startDate)} - ${DateFormat('dd MMM').format(item.endDate)} ($duration hari)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryLight,
                                     fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                       NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(totalPrice),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                         fontFamily: 'Plus Jakarta Sans',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                             provider.updateCartItem(item.id, item.quantity - 1);
                                          },
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                                            child: const Icon(Icons.remove, size: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'Plus Jakarta Sans',)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                             provider.updateCartItem(item.id, item.quantity + 1);
                                          },
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                                            child: const Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal", style: TextStyle(color: Colors.grey,  fontFamily: 'Plus Jakarta Sans',)),
                         Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(subtotal), style: const TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'Plus Jakarta Sans',)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Deposit (refundable)", style: TextStyle(color: Colors.grey,  fontFamily: 'Plus Jakarta Sans',)),
                         Text("Rp 100.000", style: TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'Plus Jakarta Sans',)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Grand Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,  fontFamily: 'Plus Jakarta Sans',)),
                        Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(subtotal + 100000), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,  fontFamily: 'Plus Jakarta Sans',)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                           // Checkout logic placeholder
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Checkout belum tersedia")));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Lanjutkan ke Checkout",
                          style: TextStyle(
                            color: AppColors.backgroundDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                             fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
