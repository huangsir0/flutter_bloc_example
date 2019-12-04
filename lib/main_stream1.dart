import 'dart:async';

void main() {
//初始化"单订阅"流控制器
  StreamController ctrl = new StreamController();

  //初始化一个subscription 订阅者
  StreamSubscription subscription = ctrl.stream
      .listen(onListen,
              onError: onError,
              onDone: onDone,
              cancelOnError: false);//cancelOnError 当有Error的时候是否关闭流

//流流入数据，能够控制何时投递消息
  ctrl.sink.add('Hello World');
  ctrl.sink.add(1234);
  ctrl.sink.addError("onError!");
  ctrl.sink.add(13.14);
  ctrl.close();
}

void onListen(event) {
  print("==>${event}");
}

void onError(error) {
  print(error);
}

void onDone() {
  print('The stream is done !');
}
