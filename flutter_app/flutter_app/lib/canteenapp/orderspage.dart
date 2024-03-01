import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
import 'package:provider/provider.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({Key? key}) : super(key: key);

  @override
  State<AllOrdersPage> createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the page is initialized
    Provider.of<OrderState>(context, listen: false).fetchAllOrders();
    Provider.of<OrderState>(context, listen: false).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    return Scaffold(
      body: orderState.orders.isEmpty
          ? const Center(
              child: Text('No orders yet!'),
            )
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: orderState.orders.length,
                itemBuilder: (context, index) {
                  final order = orderState.orders[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Date: ${order.date}')),
                        ),
                        Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'User: ${orderState.users[order.userId].username}'),
                                const Text('Ordered Items:'),
                              ],
                            ),
                            trailing: Text(
                              'Total: Rs.${order.totalAmount}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
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
