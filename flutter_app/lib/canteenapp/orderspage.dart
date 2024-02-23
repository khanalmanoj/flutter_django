import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
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
    // Fetch orders when the page is initialized
    Provider.of<OrderState>(context, listen: false).fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    return Scaffold(
      body: orderState.orders.isEmpty
          ? const Center(
              child: Text('No orders yet!'),
            )
          : ListView.builder(
              itemCount: orderState.orders.length,
              itemBuilder: (context, index) {
                final order = orderState.orders[index];
                return ListTile(
                  leading: Text("UserId: ${order.userId}"),
                  title: Text('Total Amount: ${order.totalAmount}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order.foodItemsOrdered
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
