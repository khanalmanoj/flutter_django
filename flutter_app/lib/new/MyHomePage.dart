import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/new/FoodViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  foodLists createState() => foodLists();
}

class foodLists extends State<HomePage> {
  var foodViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodViewModel = Provider.of<FoodViewModel>(context, listen: false);
    foodViewModel.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
        Scaffold(body: Consumer<FoodViewModel>(builder: (context, data, child) {
      return data.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : // ...

          ListView.builder(
              itemCount: data.foodLists.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200, // Set a fixed width for the container
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height:
                            100, // Set a smaller height for the image container
                        width: 200, // Set a fixed width for the image container
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(data.foodLists[index].image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                data.foodLists[index].title!,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Rs. ${data.foodLists[index].price!}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          data.cartLists.contains(data.foodLists[index])
                              ? foodViewModel
                                  .incrementQuantity(data.foodLists[index])
                              : foodViewModel.addCart(data.foodLists[index]);
                        },
                        child: const Text("Add to Orders"),
                      ),
                    ],
                  ),
                );
              },
            );
// ...
    })));
  }
}
