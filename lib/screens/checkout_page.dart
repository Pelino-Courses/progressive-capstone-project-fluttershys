import 'package:flutter/material.dart';
import '../models/fruit.dart';

class CheckoutPage extends StatefulWidget {
  final Fruit fruit;

  const CheckoutPage({required this.fruit, super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _addressController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _quantityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState!.validate()) {
      final totalPrice = widget.fruit.price * _quantity;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Confirmed! ✅'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product: ${widget.fruit.name}'),
              Text('Quantity: $_quantity'),
              Text('Price per unit: ${widget.fruit.price} RWF'),
              const SizedBox(height: 8),
              Text(
                'Total: $totalPrice RWF',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text('Delivery to: ${_addressController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proceed with your order')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Summary
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.fruit.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.fruit.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.fruit.price} RWF',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quantity
                const Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.shopping_cart),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Please enter a valid quantity';
                    }
                    _quantity = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Delivery Address
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Enter your delivery address',
                    hintText: 'Street, City, Postal Code',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Total Price
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.fruit.price * _quantity} RWF',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handlePlaceOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
