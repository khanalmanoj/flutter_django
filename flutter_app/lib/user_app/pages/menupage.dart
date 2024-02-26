import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/menu_view.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Menu createState() => Menu();
}

class Menu extends State<MenuPage> {
  var foodViewModel;

  @override
  void initState() {
    super.initState();
    foodViewModel = Provider.of<FoodViewModel>(context, listen: false);
    foodViewModel.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<FoodViewModel>(
          builder: (context, data, child) {
            return data.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Categories',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const Row(
                          children: [
                            Chip(label: Text("All")),
                            Chip(label: Text("Drinks")),
                            Chip(label: Text("Food")),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Drinks',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.foodLists.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 180,
                                // Set width of each card
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                data.foodLists[index].image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  data.foodLists[index].title!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  "Rs. ${data.foodLists[index].price!}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              onPressed: () {
                                                data.addToCart(
                                                    data.foodLists[index].id!);
                                                data.cartLists.contains(
                                                        data.foodLists[index])
                                                    ? foodViewModel
                                                        .incrementQuantity(data
                                                            .foodLists[index])
                                                    : foodViewModel.addCart(
                                                        data.foodLists[index]);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .add_shopping_cart_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Food Items',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.foodLists.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 180,
                                // Set width of each card
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                data.foodLists[index].image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  data.foodLists[index].title!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  "Rs. ${data.foodLists[index].price!}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              onPressed: () {
                                                data.addToCart(
                                                    data.foodLists[index].id!);
                                                data.cartLists.contains(
                                                        data.foodLists[index])
                                                    ? foodViewModel
                                                        .incrementQuantity(data
                                                            .foodLists[index])
                                                    : foodViewModel.addCart(
                                                        data.foodLists[index]);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .add_shopping_cart_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  );
          },
        ),
      ),
    );
  }
}
