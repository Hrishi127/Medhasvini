import 'package:flutter/material.dart';

class WithdrawnHistory extends StatelessWidget {
  const WithdrawnHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("History"),
      ),
    );
  }
}
