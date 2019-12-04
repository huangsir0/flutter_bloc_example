import 'dart:async';

void main() {
  StreamController<int> ctl = StreamController<int>();

  ctl.stream
      .map((value) => Data((value * 2).toString())) // int 转换为 Data 类型
      .listen((value) => print(value));

  ctl.sink.add(3);

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
