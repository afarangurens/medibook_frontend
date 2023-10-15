import 'package:flutter/material.dart';

class NotSuccessfulLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No son las credenciales'),
      ),
      body: Center(
        child: Text('No te has loggeado'), // You can customize this message
      ),
    );
  }
}
