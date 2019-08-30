import 'dart:async';

void main() {
//初始化"单订阅"流控制器
  final StreamController ctrl = new StreamController();
//初始化一个只打印数据的监听
// ignore: cancel_subscriptions
  final StreamSubscription subscription =
      ctrl.stream.listen((data) => print("$data"));
//流流入数据
  ctrl.sink.add('My Name');
  ctrl.sink.add(1234);
  ctrl.sink.add({'a': 'element A', 'b': 'element B'});
  ctrl.sink.add(123.45);
  ctrl.close();
}
