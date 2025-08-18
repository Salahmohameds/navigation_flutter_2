import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color accent = Colors.purpleAccent;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 96, color: accent),
          const SizedBox(height: 20),
          Text(
            'Welcome Home!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.explore),
            label: const Text('Explore'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
