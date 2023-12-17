import 'dart:convert';
import 'package:flutter/material.dart';
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
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> dataList = snapshot.data as List<dynamic>;

              return ListView.builder(
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
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchData() async {
  final response = await http.get(
    Uri.parse("http://127.0.0.1:8000/api/food/"),
    // Replace "your-api-endpoint" with the actual endpoint for retrieving JSON data
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
