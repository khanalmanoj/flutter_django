import 'package:flutter/material.dart';
import 'package:flutter_app/customer_app/models/menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/customer_app/models/menu_view.dart';

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
    foodViewModel.getAllMenu();
    foodViewModel.getfood();
    foodViewModel.getdrinks();
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Chip(label: Text("All")),
                                Chip(label: Text("Drinks")),
                                Chip(label: Text("Food")),
                              ],
                            ),
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
                            itemCount: data.filteredDrinks.length,
                            itemBuilder: (context, index) {
                              return buildFoodItemCard(
                                  data.filteredDrinks[index]);
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
                            itemCount: data.filteredFood.length,
                            itemBuilder: (context, index) {
                              return buildFoodItemCard(data.filteredFood[index]);
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

  Widget buildFoodItemCard(FoodModel foodItem) {
    return SizedBox(
      width: 180,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(foodItem.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        foodItem.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Rs. ${foodItem.price!}",
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
                      // Call addToCart method with foodItem.id
                      Provider.of<FoodViewModel>(context, listen: false)
                          .addToCart(foodItem.id!);
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart_outlined,
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
  }
}
