import 'package:flutter/material.dart';
import '../models/fruit.dart';
import '../main.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Fruits data moved to globalFruits in main.dart

  int totalOrders = 42;
  int totalRevenue = 145800;
  int activeUsers = 156;

  void _editProduct(Fruit fruit, int index) {
    final nameController = TextEditingController(text: fruit.name);
    final priceController = TextEditingController(text: fruit.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (RWF)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text) ?? fruit.price;
              setState(() {
                globalFruits[index] = Fruit(
                  id: fruit.id,
                  name: nameController.text,
                  price: newPrice,
                  emoji: fruit.emoji,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                globalFruits.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (RWF)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                final newPrice = double.tryParse(priceController.text) ?? 0;
                setState(() {
                  globalFruits.add(
                    Fruit(
                      id: (globalFruits.length + 1).toString(),
                      name: nameController.text,
                      price: newPrice,
                      emoji: '🍎',
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Panel'),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              isLoggedIn = false;
              isAdmin = false;
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out from admin panel')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.deepOrange,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Products'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Dashboard Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildStatCard(
                              'Total Orders',
                              totalOrders.toString(),
                              Colors.blue,
                              Icons.shopping_cart,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              'Total Users',
                              activeUsers.toString(),
                              Colors.green,
                              Icons.people,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatCard(
                              'Total Revenue',
                              '$totalRevenue RWF',
                              Colors.deepOrange,
                              Icons.attach_money,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              'Products',
                              globalFruits.length.toString(),
                              Colors.purple,
                              Icons.inventory,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _addProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Product'),
                        ),
                      ],
                    ),
                  ),
                  // Products Tab
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Product Management',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _addProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: globalFruits.length,
                            itemBuilder: (context, index) {
                              final fruit = globalFruits[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  leading: Text(
                                    fruit.emoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  title: Text(
                                    fruit.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${fruit.price} RWF',
                                    style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Text('Edit'),
                                        onTap: () => _editProduct(fruit, index),
                                      ),
                                      PopupMenuItem(
                                        child: const Text('Delete'),
                                        onTap: () => _deleteProduct(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
