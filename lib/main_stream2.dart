import 'dart:async';

//广播流
void main() {
  StreamController<int> ctrl = new StreamController<int>.broadcast();

// 第一个订阅者
  StreamSubscription subscription1 =
      ctrl.stream.listen((value) => print('第一个订阅者 $value'));

  // 第二个订阅者
  StreamSubscription subscription2 =
      ctrl.stream.listen((value) => print('第二个订阅者 $value'));

  ctrl.sink.add(2);
  ctrl.sink.add(4);

  ctrl.close();
}
