import 'package:flutter/material.dart';
import 'package:flutter_app/state/cart_state.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  void initState() {
    super.initState();
    // Fetch checkouts when the page is initialized
    Provider.of<CartState>(context, listen: false).fetchCheckouts();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = Provider.of<CartState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartState.checkouts.isEmpty
          ? Center(
              child: Text('No items in cart'),
            )
          : ListView.builder(
              itemCount: cartState.checkouts.length,
              itemBuilder: (context, index) {
                final checkout = cartState.checkouts[index];
                return ListTile(
                  title: Text('Total Amount: ${checkout.totalAmount}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: checkout.foodItemsOrdered
                        .map(
                          (item) => Text(
                            '${item.foodName}: ${item.quantity}',
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
    );
  }
}
