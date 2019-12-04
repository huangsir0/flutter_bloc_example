import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'counter_bloc.dart';

class CountPage extends StatefulWidget {
  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {

  //把一些相关的数据请求，实体类变换抽到CounterBLoC这个类里
  //实例化CounterBLoC
  final _bloc = new CounterBLoC();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CountBloc"),),
      body: StreamBuilder(
        //监听流,当流中的数据发生变化(调用过sink.add时，此处会接收到数据的变化并且刷新UI)
        stream: _bloc.stream_counter,
        initialData: 0,
        builder: (BuildContext context,AsyncSnapshot<int> snapshot){
          return Center(
            child: Text(snapshot.data.toString(),style: TextStyle(fontSize: 40,fontWeight: FontWeight.w300),),
          );
        },
      ),
      floatingActionButton: _getButton(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }




  Widget _getButton(){
    return FloatingActionButton(child: Icon(Icons.add),
        onPressed: (){
          // 点击添加；其实也是发布一个流事件
          _bloc.addCount();
        });
  }
}
