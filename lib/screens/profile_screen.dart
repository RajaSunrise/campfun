import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/app_provider.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;

    if (user == null) {
      // Should not happen if guarded, but safe fallback
      return const Scaffold(body: Center(child: Text("Silakan login")));
    }

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
          'Profil Saya',
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 18,
             fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textLight),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                image: const DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAPsoAksNCo1bdJRcmV9nKuOOspw3deBu2Ke_OncMZHl3w5ncwptnFnf9wOHtYGeGpYiB8ULeA9tap6HgDJYPYEpUdWxAcF50Z-n_utfz1wKtR0csKpMLuIxnDaMs7p5laBCgyTIeNZ0uzqv3ybblZnvChrlQnKBIYEU92ip0mOjeE35fWObe7yz1WP189lpmSdNCfASKzIE9XstygNKxrqk05--OTUZhP5IkDthZfxBeSLqB53VpBgedo1f8FFoQZu7aNLurzlUhE"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                 fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                 fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                "Edit Profil",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontFamily: 'Plus Jakarta Sans',),
              ),
            ),
            const SizedBox(height: 32),
            // Menu List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.history, "Riwayat Penyewaan"),
                  _buildMenuItem(Icons.payment, "Metode Pembayaran"),
                  _buildMenuItem(Icons.pin_drop, "Alamat Tersimpan"),
                ],
              ),
            ),
            const SizedBox(height: 16),
             Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.help_outline, "Pusat Bantuan"),
                  _buildMenuItem(Icons.info_outline, "Tentang Aplikasi"),
                ],
              ),
            ),
             const SizedBox(height: 32),
             TextButton(
               onPressed: () {
                 context.read<AppProvider>().logout();
                 Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                   (route) => false,
                 );
               },
               child: const Text(
                 "Keluar",
                 style: TextStyle(
                   color: Colors.red,
                   fontWeight: FontWeight.bold,
                   fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500,  fontFamily: 'Plus Jakarta Sans',)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
