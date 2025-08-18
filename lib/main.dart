import 'package:flutter/material.dart';
import 'bottom_navigation/bottom_navigation_page.dart';
import 'screens/home_page.dart';
import 'screens/search_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color accent = Colors.purpleAccent;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
        useMaterial3: false,
        appBarTheme: AppBarTheme(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
        ),
      ),
      home: const BottomNavigationPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
