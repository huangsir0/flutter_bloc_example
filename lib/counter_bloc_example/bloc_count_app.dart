
import 'package:flutter/material.dart';

import 'countpage.dart';

class BlocCountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Streams Demo",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountPage(),
    );
  }
}
