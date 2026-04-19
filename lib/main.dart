import 'package:flutter/material.dart';
import 'screens/home_page.dart';

// Global authentication state - Simple boolean flags
bool isLoggedIn = false;
bool isAdmin = false;

// Global fruits data
List<Fruit> globalFruits = [
  Fruit(id: '1', name: 'Passion Fruit', price: 1200, emoji: '🍎'),
  Fruit(id: '2', name: 'Kigali Bananas', price: 800, emoji: '🍌'),
  Fruit(id: '3', name: 'Fresh Mangoes', price: 1500, emoji: '🥭'),
  Fruit(id: '4', name: 'Organic Oranges', price: 900, emoji: '🍊'),
  Fruit(id: '5', name: 'Strawberries', price: 2000, emoji: '🍓'),
  Fruit(id: '6', name: 'Watermelon', price: 1800, emoji: '🍉'),
];

void main() => runApp(const FrutellaApp());

class FrutellaApp extends StatelessWidget {
  const FrutellaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frutella',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        appBarTheme: const AppBarTheme(elevation: 2, centerTitle: true),
      ),
      home: const HomePage(),
    );
  }
}
