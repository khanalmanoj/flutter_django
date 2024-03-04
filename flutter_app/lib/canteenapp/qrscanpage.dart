import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
import 'package:flutter_app/canteenapp/orderspage.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
                child: Text('Scanning QR Code',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
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

  Future<void> _handleResult(Barcode scanData) async {
    // Access the scanned data (JSON) as a String
    String? token = scanData.code;
    // print('Scanned token: $token');

    OrderState orderstate = Provider.of<OrderState>(context, listen: false);
    // Map<String, dynamic> tokendatas = await orderstate.verifyOrderToken(token!);
    Map<String, dynamic> orderdatas = await orderstate.checkOrderItem(token!);
    try {
      _showListTile(orderdatas, token);
    } catch (e) {
      Map<String, dynamic> errordata = {
        'Invalid QR Code data format': e.toString()
      };
      _showListTile(errordata, token);
      // print('Invalid QR Code data format: $e');
    }
  }

  void _showListTile(Map tokendata, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final cartState = Provider.of<CartState>(context);
        // Map<String, dynamic> data = jsonDecode(jsonString);

        return AlertDialog(
          title: const Text('Scanned Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Order Items: $tokendata'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<OrderState>(context, listen: false).checkoutOrder(token);
              },
              child: const Text('Confirm Order'),
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
