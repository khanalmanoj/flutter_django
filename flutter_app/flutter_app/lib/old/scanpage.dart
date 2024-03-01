import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanning = true;
  bool isscanned = false;
  Map<String, dynamic> jsonfinal = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _buildQrView(context),
            ),
            const Expanded(
              flex: 2,
              child: Center(
                child: Text('Scanning QR Code',style:TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderColor: Colors.red,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isscanned) {
        setState(() {
          isscanned = true;
          scanning = false;
          _handleResult(scanData);
        });
      }
    });
  }

  void _handleResult(Barcode scanData) {
    // Access the scanned data (JSON) as a String
    String? jsonString = scanData.code;

    // Print debugging information
    //print('Scanned QR Code: $jsonString');

    try {
      List<dynamic> jsonDataList = json.decode(jsonString!);
      print('Data List: $jsonDataList');

      // Process the list of data as needed
      for (int i = 0; i < jsonDataList.length; i++) {
        String foodname = jsonDataList[i]['food_name'].toString();
        print('Food Name: $foodname');
      }

      // Display the data in a ListTile or handle it as needed
      _showListTile(jsonDataList);
    } catch (e) {
      print('Invalid QR Code format');
    }
  }

  void _showListTile(List<dynamic> jsonString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scanned Data'),
          content: Column(children: <Widget>[
            for (int i = 0; i < jsonString.length; i++)
              ListTile(
                title: Text(jsonString[i]['food_name']),
                leading: Image.network(jsonString[i]['image']),
              ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
