import 'dart:async';
import 'package:flutter/material.dart';


class CountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CountApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountHomePage(),
    );
  }
}


class CountHomePage extends StatefulWidget {
  @override
  _CountHomePageState createState() => _CountHomePageState();
}

class _CountHomePageState extends State<CountHomePage> {
  int _counter =0;
  final StreamController<int> _streamController =new StreamController<int>();
  
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Stream version of the Counter App")),
      body: Center(
        // 我们正在监听流，每次有一个新值流出这个流时，我们用该值更新Text ;
        child: StreamBuilder<int>(
          stream: _streamController.stream,
          initialData: _counter,
          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
            return Text("You hit me: ${snapshot.data} times");
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          //当我们点击FloatingActionButton时，增加计数器并通过sink将其发送到Stream；
          //事实上 注入到stream中值会导致监听它(stream)的StreamBuilder重建并 ‘刷新’计数器;
          _streamController.sink.add(++_counter);
        },
      ),
    );
  }
}

