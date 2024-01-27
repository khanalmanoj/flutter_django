import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scanpage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataList = [];
  String jsonDataString = "";
  String jsonfinal = "";

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

        // Now that data is available, generate QR code
        generateQRCode();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  void generateQRCode() {
    // Assuming your JSON data structure is different, modify accordingly
    List jsonDataList = [];
    if (dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        Map<String, dynamic> jsonData = dataList[i] as Map<String, dynamic>;
        String foodName = jsonData['food_name'].toString();
        String image = jsonData['image'].toString();
        Map<String, dynamic> data = {
          "food_name": foodName,
          "image": image,
        };
        jsonDataString = json.encode(data);
        jsonDataList.add(jsonDataString);
      }
      jsonfinal = jsonDataList.toString();
      print("jsonDataString: $jsonfinal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          // Add any action you want when the ListTile is tapped
                        },
                      );
                    },
                  ),
                ),
                QrImageView(
                  data: jsonfinal,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
          ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRScannerScreen()));
            },
            child: const Text("Scan QR Code"))
      ],
    );
  }
}
