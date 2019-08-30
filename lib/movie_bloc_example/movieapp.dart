import 'package:flutter/material.dart';

import 'moviepage.dart';


class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MoviePage(),
      ),
    );
  }
}
