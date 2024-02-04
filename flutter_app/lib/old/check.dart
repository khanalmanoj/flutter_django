import 'package:flutter/material.dart';
import 'package:flutter_app/old/cart_provider.dart';
import 'package:flutter_app/old/cart_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';


class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  List<dynamic> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/food/"),
      );

      if (response.statusCode == 200) {
        setState(() {
          dataList = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Column(
        children: [
          if (dataList.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> jsonData =
                            dataList[index] as Map<String, dynamic>;

                        return ListTile(
                          title: Text(jsonData['food_name']),
                          subtitle: Text(jsonData['desc']),
                          trailing: Text(jsonData['time']),
                          leading: Image.network(jsonData['image']),
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(jsonData);
                            print('Added to cart: $jsonData');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
