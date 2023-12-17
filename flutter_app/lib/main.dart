import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Retrieval Example'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataList = [];
  String jsonDataString = "";

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
    if (dataList.isNotEmpty) {
      Map<String, dynamic> jsonData = dataList.first as Map<String, dynamic>;
      jsonDataString = jsonEncode(jsonData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dataList.isEmpty)
          CircularProgressIndicator()
        else
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> jsonData = dataList[index] as Map<String, dynamic>;

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
          data: jsonDataString,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ],
    );
  }
}
