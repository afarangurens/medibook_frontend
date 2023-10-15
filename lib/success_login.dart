import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sirvió'),
      ),
      body: Center(
        child: Text('Te has loggeado'), // You can customize this message
      ),
    );
  }
}
