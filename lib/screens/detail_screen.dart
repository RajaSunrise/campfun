import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/equipment.dart';
import '../providers/app_provider.dart';
import 'auth/login_screen.dart';

class DetailScreen extends StatefulWidget {
  final Equipment equipment;

  const DetailScreen({super.key, required this.equipment});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Image.network(
                        widget.equipment.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                              style: IconButton.styleFrom(backgroundColor: Colors.white54),
                              onPressed: () => Navigator.pop(context),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, color: AppColors.textLight),
                              style: IconButton.styleFrom(backgroundColor: Colors.white54),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Indicators (Mock)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 8, height: 8, margin: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    Container(width: 8, height: 8, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle)),
                    Container(width: 8, height: 8, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.equipment.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kategori: ${widget.equipment.category}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                             NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(widget.equipment.pricePerDay) + " / hari",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                               fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, size: 16, color: widget.equipment.available ? Colors.green : Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  widget.equipment.available ? "Tersedia" : "Tidak Tersedia",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondaryLight,
                                     fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: AppColors.primary,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: AppColors.primary,
                              tabs: [
                                Tab(text: "Deskripsi"),
                                Tab(text: "Spesifikasi"),
                                Tab(text: "Ulasan"),
                              ],
                            ),
                            SizedBox(height: 16),
                           // Content would go here, simplified for now
                          ],
                        ),
                      ),
                      Text(
                        widget.equipment.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                          height: 1.5,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 24),
                       // Date Picker
                       const Text("Pilih Tanggal Sewa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,  fontFamily: 'Plus Jakarta Sans',)),
                       const SizedBox(height: 8),
                       InkWell(
                         onTap: () async {
                           final picked = await showDateRangePicker(
                             context: context,
                             firstDate: DateTime.now(),
                             lastDate: DateTime.now().add(const Duration(days: 365)),
                           );
                           if (picked != null) {
                             setState(() {
                               _selectedDateRange = picked;
                             });
                           }
                         },
                         child: Container(
                           padding: const EdgeInsets.all(12),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey.shade300),
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 _selectedDateRange == null
                                     ? "Pilih tanggal"
                                     : "${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}",
                                     style: const TextStyle( fontFamily: 'Plus Jakarta Sans',),
                               ),
                               const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                             ],
                           ),
                         ),
                       ),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Jumlah",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                               fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_quantity > 1) setState(() => _quantity--);
                                },
                                icon: const Icon(Icons.remove),
                                style: IconButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text("$_quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: 'Plus Jakarta Sans',)),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                                icon: const Icon(Icons.add, color: AppColors.primary),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary.withOpacity(0.2),
                                  side: const BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedDateRange == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih tanggal sewa terlebih dahulu")));
                    return;
                  }

                  final success = await context.read<AppProvider>().addToCart(
                    widget.equipment,
                    _quantity,
                    _selectedDateRange!.start,
                    _selectedDateRange!.end
                  );

                  if (mounted) {
                     if (success) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil ditambahkan ke keranjang")));
                       Navigator.pop(context);
                     } else {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silakan login terlebih dahulu")));
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                     }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundDark,
                     fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
