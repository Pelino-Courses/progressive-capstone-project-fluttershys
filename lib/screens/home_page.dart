import 'package:flutter/material.dart';
import '../main.dart';
import '../models/fruit.dart';
import 'signin_page.dart';
import 'signup_page.dart';
import 'checkout_page.dart';
import 'admin_page.dart';

// Fruit Model moved to models/fruit.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fruits data moved to globalFruits in main.dart

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍓 Frutella'),
        actions: [
          if (isLoggedIn && isAdmin)
            IconButton(
              tooltip: 'Admin Panel',
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
            ),
          if (isLoggedIn)
            TextButton(
              onPressed: () {
                isLoggedIn = false;
                isAdmin = false;
                _refreshPage();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            )
          else ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                ).then((_) => _refreshPage());
              },
              child: const Text('Sign In', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                ).then((_) => _refreshPage());
              },
              child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: globalFruits.length,
          itemBuilder: (context, index) {
            return _buildFruitCard(context, globalFruits[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFruitCard(BuildContext context, Fruit fruit) {
    return FruitCard(
      fruit: fruit,
      onPlaceOrder: () {
        if (!isLoggedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please sign in to place an order'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignInPage(redirectToCheckout: true, fruit: fruit),
            ),
          ).then((_) => _refreshPage());
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(fruit: fruit),
            ),
          );
        }
      },
    );
  }
}

class FruitCard extends StatefulWidget {
  final Fruit fruit;
  final VoidCallback onPlaceOrder;

  const FruitCard({required this.fruit, required this.onPlaceOrder, super.key});

  @override
  State<FruitCard> createState() => _FruitCardState();
}

class _FruitCardState extends State<FruitCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _isPressed ? 0.98 : 1.0,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.orange.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.fruit.emoji, style: const TextStyle(fontSize: 56)),
              Column(
                children: [
                  Text(
                    widget.fruit.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.fruit.price} RWF',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTapDown: (_) => _setPressed(true),
                onTapUp: (_) => _setPressed(false),
                onTapCancel: () => _setPressed(false),
                child: ElevatedButton(
                  onPressed: widget.onPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Place Order', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
