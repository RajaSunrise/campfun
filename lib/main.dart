import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'screens/welcome_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _appProvider = AppProvider();
    // Use addPostFrameCallback to ensure the provider is inserted into the tree (if needed)
    // or just to break execution flow. However, we are passing it to ChangeNotifierProvider.
    // Calling loadInitialData here is safe because no one is listening yet.
    _appProvider.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appProvider),
      ],
      child: MaterialApp(
        title: 'CampFun',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.backgroundLight,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
