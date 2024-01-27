import 'package:flutter/material.dart';
import 'package:flutter_app/pages/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
 
  @override
  Widget build(BuildContext context) {
    print('Building CartScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          print('Cart Items Count: ${cartProvider.cartItems}');
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> cartItem =
                        cartProvider.cartItems[index] as Map<String, dynamic>;

                    if (cartItem.isEmpty) {
                      return const Center(
                        child: Text('Cart is empty'),
                      );
                    } else {
                      return
                      ListTile(
                        title: Text(cartItem['food_name']),
                        subtitle: Text(cartItem['desc']),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            cartProvider.removeFromCart(index);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  cartProvider.clearCart();
                },
                child: Text('Clear Cart'),
              ),
            ],
          );
        },
      ),
    );
  }
}
