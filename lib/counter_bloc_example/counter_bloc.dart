import 'dart:async';

class CounterBLoC{

  //记录按钮点击的次数
  //被流包裹的数据(可以是任何类型)
  int _counter =0;

  //流控制
  final _counterStreamController =new StreamController<int>();

  //流
  Stream<int> get stream_counter=> _counterStreamController.stream;


   // 通过sink.add发布一个流事件
  void addCount(){
    _counterStreamController.sink.add(++_counter);
  }


   //释放流
   void dispose(){

     _counterStreamController.close();
   }

}