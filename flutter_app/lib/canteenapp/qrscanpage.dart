import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
import 'package:flutter_app/canteenapp/orderspage.dart';
import 'package:flutter_app/user_app/state/cart_state.dart';
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

  void _handleResult(Barcode scanData) {
    // Access the scanned data (JSON) as a String
    String? jsonString = scanData.code;
    try {
      _showListTile(jsonString!);
    } catch (e) {
      print('Invalid QR Code data format: $e');
    }
  }

  void _showListTile(String jsonString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final cartState = Provider.of<CartState>(context);
        Map<String, dynamic> data = jsonDecode(jsonString);
        int orderid = data['orderid'];
        int userid = data['userid'];
        return AlertDialog(
          title: const Text('Scanned Data'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Order ID: $orderid'),
              Text('User ID: $userid'),
            ],
          ),
          // ListView.builder(
          //   itemCount: cartState.orderModels[orderid].order_items?.length,
          //   itemBuilder: (context, index) {
          //     final order = cartState.orderModels[orderid].order_items![index];
          //     return const Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('foodname'), // need to make field of foodname in cart model i.e. in orderitem model to get fooodname
          //           Text(order.quantity!.toString())
          //         ]);
          //   },
          // ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<OrderState>(context, listen: false)
                    .checkoutOrder(orderid, userid);
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AllOrdersPage()));
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
