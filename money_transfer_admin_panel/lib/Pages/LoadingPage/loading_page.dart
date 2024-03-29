import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    Key key,
  }) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Loading ....",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
