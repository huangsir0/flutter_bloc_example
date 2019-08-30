import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'counter_bloc.dart';
import 'counter_event.dart';

class CountPage extends StatefulWidget {
  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  final _bloc = new CounterBLoC();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CountBloc"),),
      body: _getBody(),
      floatingActionButton: _getButton(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  Widget _getBody(){
    return StreamBuilder(
      stream: _bloc.stream_counter,
      initialData: 0,
      builder: (BuildContext context,AsyncSnapshot<int> snapshot){
        return Center(
          child: Text(snapshot.data.toString()),
        );
    },
    );
  }
  
  Widget _getButton(){
    return FloatingActionButton(child: Icon(Icons.add),
        onPressed: (){
          _bloc.counter_event_sink.add(new IncrementEvent());
        });
  }
}
