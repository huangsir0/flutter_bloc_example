import 'dart:async';

//广播流,StreamTransformer过滤值
void main() {
  ///
  /// Initialize a "Broadcast" Stream controller of integers
  ///
  final StreamController<int> ctrl = new StreamController<int>.broadcast();
  // ignore: cancel_subscriptions
  final StreamSubscription subscription =ctrl.stream.where((value)=>(value%2==0))
  // ignore: cancel_subscriptions
  .listen((value)=>print("$value"));
  for(int i=1;i<=11;i++){
    ctrl.sink.add(i);
  }
  ctrl.close();
}
