import 'dart:async';

//由int类型转换为Data类型
void main() {
  StreamController ctl = StreamController<int>();

  // 创建 StreamTransformer对象
  StreamTransformer stf = StreamTransformer<int, Data>.fromHandlers(
    handleData: (int data, EventSink sink) {
      // 操作数据后，转换为 Data 类型
      sink.add(Data((data * 2).toString()));
    },
  );
  // 调用流的transform方法，传入转换对象
  Stream stream = ctl.stream.transform(stf);
  stream.listen(print);

  // 添加数据，这里的类型是int
  ctl.add(3);

  // 调用后，触发handleDone回调
  ctl.close();
}

class Data {
  final String name;

  Data(this.name);

  @override
  String toString() {
    // TODO: implement toString
    return "data=> ${this.name}";
  }
}
