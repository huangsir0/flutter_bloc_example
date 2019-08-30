import 'dart:async';

import 'counter_event.dart';
class CounterBLoC{
  int _counter =0;

  final _counterStreamController =new StreamController<int>();

  // ignore: non_constant_identifier_names
  StreamSink<int> get counter_sink=>_counterStreamController.sink;

  // ignore: non_constant_identifier_names
  Stream<int> get stream_counter=> _counterStreamController.stream;

  final _counterEventController =StreamController<CounterEvent>();



  // ignore: non_constant_identifier_names
  Sink<CounterEvent> get counter_event_sink=>_counterEventController.sink;

  CounterBLoC(){
    _counterEventController.stream.listen(_count);
  }

  _count(CounterEvent event){
    counter_sink.add(++_counter);
  }


   void dispose(){
     _counterEventController.close();
     _counterStreamController.close();
   }
}