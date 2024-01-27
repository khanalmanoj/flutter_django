import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/new/FoodViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          : ListView.builder(
              itemCount: data.productLists.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    data.productLists[index].image!),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            data.productLists[index].title!,
                            style: const TextStyle(fontSize: 20),
                          )),
                        ],
                      )),
                      Text(
                        "Rs. ${data.productLists[index].price!}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            data.cartLists.contains(data.productLists[index])
                                ? foodViewModel
                                    .incrementQuantity(data.productLists[index])
                                : foodViewModel
                                    .addCart(data.productLists[index]);
                          },
                          child: const Text("Add to cart"))
                    ],
                  ),
                );
              });
    })));
  }
}
