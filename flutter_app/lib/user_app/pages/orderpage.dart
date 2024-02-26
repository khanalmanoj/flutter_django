import 'package:flutter/material.dart';
import 'package:flutter_app/models/menu.dart';
import 'package:flutter_app/models/menu_view.dart';
import 'package:flutter_app/models/orders_history.dart';
import 'package:flutter_app/user_app/authentication/loginmodel.dart';
import 'package:flutter_app/user_app/authentication/user_cubit.dart';
import 'package:flutter_app/user_app/state/cart_state.dart';
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
    Provider.of<FoodViewModel>(context, listen: false).getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final List<OrderModel> orderModels =
        Provider.of<CartState>(context).orderModels;
    final List<FoodModel> foodModels =
        Provider.of<FoodViewModel>(context).foodLists;
    User user = context.read<UserCubit>().state;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: orderModels.length,
          itemBuilder: (ctx, index) {
            final OrderModel orderModel = orderModels[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Date: ${orderModel.dateTime}"),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderModel.order_items!.length,
                  itemBuilder: (ctx, i) {
                    var item = orderModel.order_items![i];
                    FoodModel? foodModel = foodModels.firstWhere(
                      (food) => food.id == item.foodId,
                    );
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
                                            image:
                                                NetworkImage(foodModel.image!),
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    foodModel.title.toString(),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rs. ${foodModel.price}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Quantity: ${item.quantity}"),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () async {
                                Provider.of<CartState>(context, listen: false)
                                    .deleteOrderitem(item.id!);
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 36,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    );
                  },
                ),
                Text(
                  "Total: Rs.${orderModel.total}",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
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
                                    Map<String, dynamic> orderToQR = {
                                      "orderid": orderModel.id,
                                      "userid": user.id,
                                    };
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Your QR Code')),
                                          content: SizedBox(
                                            height: 400,
                                            width: 400,
                                            child: QrImageView(
                                              data: orderToQR.toString(),
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
                                },
                          child: const Text("Cancel Order"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
