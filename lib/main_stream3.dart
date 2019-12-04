import 'dart:io';

void main() {
  // stream_periodic();

  //stream_fromFuture();

 // stream_fromFutures();

  //stream_fromIterable();

  //stream_take();

  //stream_takeWhile();

   //stream_skip();

  //stream_skipWhile();

  stream_toList();
}

int _periodic_callback(int value) {
  return 2 * value;
}

stream_periodic() async {
  Duration _duration = Duration(seconds: 2);
  /**
   * 官方注释：
   * Creates a stream that repeatedly emits events at [period] intervals.
   *
   * The event values are computed by invoking [computation]. The argument to
   * this callback is an integer that starts with 0 and is incremented for
   * every event.
   *
   * If [computation] is omitted the event values will all be `null`.
   *
   * 大体意思就是：
   *
   * _periodic_callback方法计算处理后的值(起始值为0，不断递增),每隔2秒不断的生成包含int结果的事件，
   *
   * 如果省略了回调，则事件值将全部为null
   *
   *
   */
  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);

  //1.
  //int v = await stream.first;
  //print(v);

  //2.
  await for (int value in stream) {
    print("=>$value");
  }

  //3. 比方法2友好很多
  stream.listen((value) {
    print("===>$value");
  });

  /**
   *  1与2或3不能同时解开注释，但2和3 可以同时解开注释，但只会输出监听2;
   *
   *  因为2和3其实是一样的，单监听一次之后则事件消费
   */
}

stream_fromFuture() async {
  print("start");
  Future<String> _future = Future(() {
    sleep(Duration(seconds: 2));
    return "Sleep 2 秒";
  });
  //从Future创建一个Stream，可见只能穿一个Future
  Stream<String> stream = Stream.fromFuture(_future);

  stream.listen((value) {
    print("=>${value}");
  });
  print("end");
}

stream_fromFutures() async {
  Future<String> _future1 = Future(() {
    return "我没睡";
  });

  Future<String> _future2 = Future(() {
    sleep(Duration(seconds: 2));
    return "Sleep 2 秒";
  });

  Stream<String> stream = Stream.fromFutures([_future2, _future1]);

  stream.listen((value) {
    print("=>${value}");
  });
}


stream_fromIterable() async{

  Stream<String> stream =Stream.fromIterable(["路人甲","炮灰乙","流氓丙"]);

  stream.listen((value){
    print("=>${value}");
  });

}


stream_take() async {
  Duration _duration = Duration(seconds: 2);

  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);

  //只截取了前5个事件
  stream = stream.take(5);

  stream.listen((value) {
    print("===>$value");
  });
}

stream_takeWhile() async {
  Duration _duration = Duration(seconds: 2);
  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);
  //筛选符合条件的事件
  stream = stream.takeWhile(condition);

  stream.listen((value) {
    print("===>$value");
  });
}

bool condition(int value) {
  //不满足条件的不监听
  return value < 12;
}

//
stream_skip() async {
  Duration _duration = Duration(seconds: 2);
  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);

  stream = stream.take(10);

  //跳过前两个事件
  stream = stream.skip(2);

  stream.listen((value) {
    print("===>$value");
  });
}

stream_skipWhile() async {
  Duration _duration = Duration(seconds: 2);
  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);

  stream = stream.take(10);
  //跳转到满足值得事件
  stream = stream.skipWhile(condition);
  stream.listen((value) {
    print("===>$value");
  });
}

stream_toList() async {
  Duration _duration = new Duration(seconds: 2);
  Stream<int> stream = Stream.periodic(_duration, _periodic_callback);
  stream = stream.take(5);
  //因为是异步的，所以有 await，返回已经完成的事件列表
  List<int> datas = await stream.toList();

  for (int i in datas) {
    print("===>$i");
  }
}
