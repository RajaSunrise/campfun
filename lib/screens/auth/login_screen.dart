import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/app_provider.dart';
import 'register_screen.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Header Image Half Screen (simplified implementation)
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundLight,
                  ),
                  child: Stack(
                    children: [
                       Container(
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAFKuyv-gKPOecKdnANeTXFJ3m5WPLumOl44cvd-KRxEGW9v14ehp95mTW_-duC7wXP2ZH7bzUk4EevteLkNDgVi5ryLevZURsdFX0KeeVpBvSCljqfqVx4brBxmgLanuK6e-eQ7JiKj1Guw_uxApJWYu7tR8yeVJmlXTg7UeGesIGb6AdRhp9srJoaF9InFmyNSdKz00Lp7j8Qw4SGSmPrXOaQYlI1LJy2u_s1jBxW2_6GKzMsCrqsOUqMxFUgDx14zUWX4r9SV6w"),
                             fit: BoxFit.cover,
                             opacity: 0.2
                           )
                         ),
                       ),
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.filter_hdr, size: 64, color: AppColors.textSecondaryLight),
                            SizedBox(height: 8),
                            Text(
                              'CampFun',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                                 fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            SizedBox(height: 32)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Selamat Datang Kembali',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                           fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Email/Username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,  fontFamily: 'Plus Jakarta Sans',)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person, color: AppColors.textSecondaryLight),
                              filled: true,
                              fillColor: AppColors.inputBgLight,
                              hintText: "Masukkan email atau username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kata Sandi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,  fontFamily: 'Plus Jakarta Sans',)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: AppColors.textSecondaryLight),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.textSecondaryLight,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: AppColors.inputBgLight,
                              hintText: "Masukkan kata sandi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                       const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              decoration: TextDecoration.underline,
                               fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await context.read<AppProvider>().login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login gagal. Periksa email/password.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Consumer<AppProvider>(
                            builder: (context, provider, child) {
                              return provider.isLoading
                                  ? const CircularProgressIndicator(color: AppColors.backgroundDark)
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: AppColors.backgroundDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                         fontFamily: 'Plus Jakarta Sans',
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? ", style: TextStyle( fontFamily: 'Plus Jakarta Sans',)),
                          GestureDetector(
                            onTap: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Daftar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                                 fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
