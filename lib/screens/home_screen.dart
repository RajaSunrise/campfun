import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/app_provider.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 0: Home/Search, 1: Cart, 2: Profile
  String _searchQuery = "";
  String _selectedCategory = "Semua";

  final List<String> _categories = ["Semua", "Tenda", "Tas Carrier", "Alat Masak", "Lainnya"];

  void _onItemTapped(int index) {
    if (index == 0) {
       setState(() {
        _selectedIndex = 0;
      });
    } else if (index == 2) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final equipmentList = context.watch<AppProvider>().equipment;
    final filteredEquipment = equipmentList.where((e) {
      final matchesSearch = e.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "Semua" || e.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                onPressed: () {
                   // In a real app logic, maybe exit or go back if pushed
                },
              ),
              const Expanded(
                child: Text(
                  'Peralatan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                     fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.textLight),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari peralatan (e.g., tenda)",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                         fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredEquipment.length,
              itemBuilder: (context, index) {
                final item = filteredEquipment[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(equipment: item),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(item.pricePerDay) + " /hari",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Text(
                        item.available ? "Tersedia" : "Tidak Tersedia",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: item.available ? AppColors.textSecondaryLight : Colors.red,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.textLight,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // Stay
          } else if (index == 1) {
             // Search tab, stay here essentially as home is search
          } else if (index == 2) {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
          } else if (index == 3) {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Telusuri"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
