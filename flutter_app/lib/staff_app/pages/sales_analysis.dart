import 'package:flutter/material.dart';

class SalesAnalysis extends StatefulWidget {
  const SalesAnalysis({Key? key}) : super(key: key);

  @override
  State<SalesAnalysis> createState() => _SalesAnalysisState();
}

class _SalesAnalysisState extends State<SalesAnalysis> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Sales Analysis'),
    ));
  }
}
