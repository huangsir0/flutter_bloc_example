import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/beauty_bloc_example/beauty_base_bloc.dart';
import 'package:flutter_bloc_example/bloc_provider.dart';

import 'beauty_base_page.dart';
import 'beautypage.dart';

class BeautyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "BeautyBloc Demo",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<BeautyBaseBloc>(
          child: BeautyBasePage(), bloc: new BeautyBaseBloc()),
    );
  }
}
