import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/new/FoodViewModel.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var foodViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodViewModel = Provider.of<FoodViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Consumer<FoodViewModel>(builder: (context, data, child) {
              return Row(
                children: <Widget>[
                  Expanded(
                      child: Text("My Cart (${data.countCart.toString()})")),
                  Text("Total Price: ${data.totalPrice}"),
                ],
              );
            })),
            floatingActionButton: FloatingActionButton(
                onPressed: () {}, child: const Icon(Icons.qr_code)),
            body: Consumer<FoodViewModel>(builder: (context, data, child) {
              return ListView.builder(
                  itemCount: foodViewModel.cartLists.length,
                  itemBuilder: (count, index) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        data.cartLists[index].image!),
                                    fit: BoxFit.cover)),
                          ),
                          Expanded(
                              child: Text(
                                  "${data.cartLists[index].title!}/${data.cartLists[index].price}")),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                // Quantity display and buttons
                                Text(
                                    "Quantity: ${data.cartLists[index].quantity}"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    foodViewModel.incrementQuantity(
                                        data.cartLists[index]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    foodViewModel.decrementQuantity(
                                        data.cartLists[index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              foodViewModel.removeCart(data.cartLists[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            })));
  }
}
