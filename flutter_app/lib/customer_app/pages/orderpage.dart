import 'package:flutter/material.dart';
import 'package:flutter_app/customer_app/models/menu.dart';
import 'package:flutter_app/customer_app/models/menu_view.dart';
import 'package:flutter_app/customer_app/models/orders_history.dart';
import 'package:flutter_app/customer_app/state/cart_state.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CartScreens extends StatefulWidget {
  static const routeName = '/cart-screens';

  const CartScreens({Key? key}) : super(key: key);

  @override
  State<CartScreens> createState() => _CartScreensState();
}

class _CartScreensState extends State<CartScreens> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartState>(context, listen: false).getOrderDatas();
    Provider.of<FoodViewModel>(context, listen: false).getAllMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<CartState>(
          builder: (context, cartState, child) {
            final List<OrderModel> orderModels = cartState.orderModels;
            return ListView.separated(
              itemCount: orderModels.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (ctx, index) {
                final OrderModel orderModel = orderModels[index];
                return OrderItemWidget(orderModel: orderModel);
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderItemWidget({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FoodModel> foodModels =
        Provider.of<FoodViewModel>(context).menuLists;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: orderModel.order_items!.length,
          itemBuilder: (ctx, i) {
            var item = orderModel.order_items![i];
            FoodModel? foodModel = foodModels.firstWhere(
              (food) => food.id == item.foodId,
              orElse: () =>
                  FoodModel(), // Return an empty FoodModel if not found
            );
            return OrderItemCard(orderItem: item, foodModel: foodModel);
          },
        ),
        Text(
          "Total: Rs.${orderModel.total}",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: orderModel.order_items!.isEmpty
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Center(child: Text('Your QR Code')),
                                  content: SizedBox(
                                    height: 400,
                                    width: 400,
                                    child: QrImageView(
                                      data: orderModel.token!,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                    child: const Text("Create Qr"),
                  ),
                ),
                ElevatedButton(
                  onPressed: orderModel.order_items!.isEmpty
                      ? null
                      : () {
                          Provider.of<CartState>(context, listen: false)
                              .deleteOrder(orderModel.id!);
                          Provider.of<CartState>(context, listen: false)
                              .getOrderDatas(); // Fetch updated order data
                        },
                  child: const Text("Cancel Order"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem orderItem;
  final FoodModel? foodModel;

  const OrderItemCard(
      {Key? key, required this.orderItem, required this.foodModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(foodModel?.image ??
                            ''), // Use foodModel's image or empty string if null
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    foodModel?.title ??
                        '', // Use foodModel's title or empty string if null
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rs. ${foodModel?.price ?? 0}", // Use foodModel's price or 0 if null
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("Quantity: ${orderItem.quantity}"),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              await Provider.of<CartState>(context, listen: false)
                  .deleteOrderitem(orderItem.id!);
              Provider.of<CartState>(context, listen: false)
                  .getOrderDatas(); // Fetch updated order data
            },
            icon: const Icon(
              Icons.delete,
              size: 36,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
