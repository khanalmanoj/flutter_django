import 'package:flutter/material.dart';
import 'package:flutter_app/customer_app/state/cart_state.dart';
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
      body: cartState.checkouts.isEmpty
          ? const Center(
              child: Text('No items in cart'),
            )
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: cartState.checkouts.length,
                itemBuilder: (context, index) {
                  final checkout = cartState.checkouts[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Date: ${checkout.date}')),
                        ),
                        Card(
                          child: ListTile(
                            title: const Text('Ordered Items:'),
                            trailing: Text(
                              'Total: Rs.${checkout.totalAmount}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
