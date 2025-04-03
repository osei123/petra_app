import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/preferences_service.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pressure_screen.dart';
import 'screens/volume_screen.dart';
import 'screens/flow_rate_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Petra - Oil & Gas Converter',
            theme: themeProvider.currentTheme,
            home: const SplashScreen(),
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/home': (context) => const HomeScreen(),
              '/pressure': (context) => const PressureScreen(),
              '/volume': (context) => const VolumeScreen(),
              '/flow-rate': (context) => const FlowRateScreen(),
              '/settings': (context) => const SettingsScreen(),
              // We'll add more routes as we create the screens
            },
          );
        },
      ),
    );
  }
}
