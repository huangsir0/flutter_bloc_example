import 'package:flutter/material.dart';

import 'dogpage.dart';

class DogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "DogBloc Demo",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DogPage(),
    );
  }
}



