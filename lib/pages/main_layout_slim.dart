import 'package:flutter/material.dart';

class MainLayoutSlim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SlimLayout"
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color.fromRGBO(38, 38, 47, 1),
        child: Text("SlimBody")
      ),
    );
  }
}