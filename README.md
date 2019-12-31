# flutter_bloc_example


### BLoC

其全称为 Business Logic Component,表示为业务逻辑组件,简称 BLoC。从其名字来看感觉和
业务逻辑有关系。由下图

#### 效果图 1

看出，BLoC 是独立处理业务逻辑，网络数据请求等等逻辑的一个模块，通过流的 Sinks, Streams 发布监听业务处理后的数据结果，其只关心业务处理，而 Widget 着重看中业务处理后的结果显示。可见，Bloc 使得业务逻辑和 UI 相分离，这有几点好处：

- 当业务逻辑内部改动时,尽可能的减少 UI 程序的改动。


- 当我们改动 UI 时不会对业务逻辑产生影响


- 方便我们测试业务逻辑功能

### Stream 简单实现的 BLoC

如果你不知道什么是 Stream，那可以点此
[什么是 Stream？ Dart](https://mp.weixin.qq.com/s?__biz=MzU0OTk2MjMwNA==&mid=2247483938&idx=1&sn=e015b6075db6805903d3194f69fb1d8f&chksm=fba6950dccd11c1bfbf1dbad333986be3b5c860ab1a58e35e3d88b57341586310ac41f79cc87&token=1384658154&lang=zh_CN#rd)
学习。

我们简单地实现一个记录按钮点击次数的 demo。

#### BLoC 的实现

##### counter_bloc 类

```dart
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
```

这个 CounterBLoC 的业务逻辑就是维护\_counter 的值，除了 addCount 方法，你还可以写其他改变\_counter 值的方法，但要想改变过后的值被监听到，则要调用 sink.add。

#### BLoC 的使用

```dart
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
    //关闭流
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

```

当我们点击 floatActionButton 的时候，bloc 中的\_counter 会增加，然后 sink.add 会通知监听者（CountPage）
\_counter 数据发生变化，CountPage 刷新 UI。

#### 效果图 2

这个案例虽然小，但是也能说明以上的好处，就是：

- 业务与逻辑分离

我们可以修改业务类 CounterBLoC 逻辑，而尽可能的减少 UI 的改动；反之改动 UI 界面，也不会影响到业务层代码。

- 业务逻辑测试更加容易（不用在写测试界面）

* 相比 setState() 刷新，能大大减少 build 的次数

### RxDart 实现的 BLoC

除了 Stream 之外，rxdart 也能帮助我们实现 Bloc 模式。

RxDart 扩展了原始的 Stream，它和 Stream 之间的对应关系如下：

|       Dart       |   RxDart   |
| :--------------: | :--------: |
|      Stream      | Observable |
| StreamController |  Subject   |

在使用 RxDart 时先将其加入依赖：

```
dependencies:
  flutter:
    sdk: flutter

  rxdart: ^0.22.0
```

#### 网络请求层

- BeautyModel 实体类

```dart
class BeautyModel {
  String sId;
  String createdAt;
  String desc;
  List<String> images;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;

  BeautyModel(
      {this.sId,
        this.createdAt,
        this.desc,
        this.images,
        this.publishedAt,
        this.source,
        this.type,
        this.url,
        this.used,
        this.who});

  BeautyModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    images =json['images']==null?null:json['images'].cast<String>();
    publishedAt = json['publishedAt'];
    source = json['source'];
    type = json['type'];
    url = json['url'];
    used = json['used'];
    who = json['who'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['desc'] = this.desc;
    data['images'] = this.images;
    data['publishedAt'] = this.publishedAt;
    data['source'] = this.source;
    data['type'] = this.type;
    data['url'] = this.url;
    data['used'] = this.used;
    data['who'] = this.who;
    return data;
  }


  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
```

- NetApi 类

```dart
import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'beauty_model.dart';

class NetApi {
  Client client = new Client();

  Future<List<BeautyModel>> fetchBeauties() async {
    print("Starting get beauties ..");
    List models = List();
    final response =
        await client.get("http://gank.io/api/data/福利/15/1");
    if (response.statusCode == 200) {
      models = json.decode(response.body)["results"];
      return models.map((model){
        return BeautyModel.fromJson(model);
      }).toList();
    } else {
      throw Exception('Failed to load dog');
    }
  }
}

```

#### BLoC 类的实现

```dart

import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import 'beauty_model.dart';
import 'net_api.dart';

class BeautyBloc {

  //网络请求的实例
  NetApi _netApi =new NetApi();

  final _beautyFetcher = PublishSubject<List<BeautyModel>>();

  //提供被观察的List<BeautyModel
  Observable<List<BeautyModel>> get beauties =>_beautyFetcher.stream;

  //获取网络数据
  fetchBeauties() async{

    List models = await _netApi.fetchBeauties();

    if(_beautyFetcher.isClosed)return;

    _beautyFetcher.sink.add(models);
  }

  //释放
  dispose(){
    _beautyFetcher?.close();
  }
}
```

#### BLoC 的使用

```dart
import 'package:flutter/material.dart';

import 'beauty_bloc.dart';
import 'beauty_model.dart';

class BeautyPage extends StatefulWidget {
  @override
  _BeautyPageState createState() => _BeautyPageState();
}

class _BeautyPageState extends State<BeautyPage> {
  final _beautyBloc = BeautyBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _beautyBloc.fetchBeauties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BeautyPage"),
      ),
      body: Container(
          child: StreamBuilder(
              //监听流
              stream: _beautyBloc.beauties,
              builder: (context, AsyncSnapshot<List<BeautyModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            snapshot.data[index].url,
                            fit: BoxFit.fill,
                          ));
                    },
                    itemCount: snapshot.data.length,
                  );
                } else if (snapshot.hasError) {
                  return Text('Beauty snapshot error!');
                }
                return Text('Loading Beauties..');
              })),
    );
  }
}

```

#### 效果图 3

以上就是 Bloc 的简单使用，但是我发现每次都要 dispose()释放，感觉有点麻烦，所以急需一个通用的 Bloc 管理类，我们就用 StatefulWidget 把 Bloc 包起来。其代码如下:

### BlocProvider

```dart
import 'package:flutter/material.dart';

import 'beauty_bloc_example/net_api.dart';

//获类型
Type _typeOf<T>() {
  return T;
}

abstract class BlocBase {
  //一些网络接口API
  NetApi netApi = new NetApi();

  //释放
  void dispose();
}

//更方便的管理Bloc
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc; //bloc

  final Widget child; //子Widget

  //构造
  const BlocProvider({Key key,@required this.bloc, @required this.child}) : super(key: key);

  //通过ancestorInheritedElementForWidgetOfExactType获取
  //bloc 实例
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
  @override
  _BlocProviderState<T> createState() {
    // TODO: implement createState
    return _BlocProviderState();
  }
}

class _BlocProviderState<T extends BlocBase>
    extends State<BlocProvider<BlocBase>> {
  @override

  /// 便于资源的释放
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}


```

#### 对 BlocProvider 的一些相关说明

由于 InheritedWidget 中并没有 dispose() 方法,所以仅仅只在 InheritedWidget 中无法及时的释放资源，所以引用了 StatefulWidget。那为什么不简简单单的只用 StatefulWidget，还要套一层 InheritedWidget 呢？这是由于 InheritedWidget 使得性能更好,如果你不了解 InheritedWidget,那么[InheritedWidget 的运用与源码解析](https://mp.weixin.qq.com/s?__biz=MzU0OTk2MjMwNA==&mid=2247483946&idx=1&sn=e7f4c267f3c115a6984b4f3ba04deee8&chksm=fba69505ccd11c1336e6ebb591447976c69665a7c0aea0926df8e5890e72198b4e9e07a2525c&token=1384658154&lang=zh_CN#rd)将会帮你更好的认识 InheritedWidget。

当然，如果我们不用 InheritedWidget 也行,只要将 of 方法中的实现改为：

```dart
 static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }
```

，然后 build 方法直接返回 widget.bloc 即可。

但是我们看 context.ancestorWidgetOfExactType()的方法如下：

```dart
 @override
  Widget ancestorWidgetOfExactType(Type targetType) {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element ancestor = _parent;
    while (ancestor != null && ancestor.widget.runtimeType != targetType)
      ancestor = ancestor._parent;
    return ancestor?.widget;
  }
```

这个方法会不断地循环往上找，如果嵌套太深，效率上会受到影响，而 InheritedWidget 不会，具体说明看上文。既然我们用了 InheritedWidget，那为什么我们用的是 context.ancestorInheritedElementForWidgetOfExactType()方法而不是我们在 InheritedWidget 文中使用的 context.inheritFromWidgetOfExactType()方法呢？看一下源码你就知道了：

- inheritFromWidgetOfExactType

```dart
  @override
  InheritedWidget inheritFromWidgetOfExactType(Type targetType, { Object aspect }) {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    final InheritedElement ancestor = _inheritedWidgets == null ? null : _inheritedWidgets[targetType];
    if (ancestor != null) {
      assert(ancestor is InheritedElement);
      //多出了刷新依赖Widget的逻辑
      return inheritFromElement(ancestor, aspect: aspect);
    }
    _hadUnsatisfiedDependencies = true;
    return null;
  }



 @override
  InheritedWidget inheritFromElement(InheritedElement ancestor, { Object aspect }) {
    assert(ancestor != null);
    _dependencies ??= HashSet<InheritedElement>();
    _dependencies.add(ancestor);
    ancestor.updateDependencies(this, aspect);
    return ancestor.widget;
  }
```

- ancestorInheritedElementForWidgetOfExactType

```dart
 @override
  InheritedElement ancestorInheritedElementForWidgetOfExactType(Type targetType) {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    final InheritedElement ancestor = _inheritedWidgets == null ? null : _inheritedWidgets[targetType];
    return ancestor;
  }
```

可见 inheritFromWidgetOfExactType 除了获取最近的 InheritedWidget 还刷新了以来的控件，而我们这里并不需要刷新，所以改用 ancestorInheritedElementForWidgetOfExactType。

#### BlocProvider 的使用

- BeautyBaseBloc 类

```dart

import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import 'beauty_model.dart';
import 'net_api.dart';

class BeautyBaseBloc extends BlocBase {


  final _beautyFetcher = PublishSubject<List<BeautyModel>>();

  //提供被观察的List<BeautyModel
  Observable<List<BeautyModel>> get beauties =>_beautyFetcher.stream;

  //获取网络数据
  fetchBeauties() async{

    List models = await netApi.fetchBeauties();

    if(_beautyFetcher.isClosed)return;

    _beautyFetcher.sink.add(models);
  }



 @override
  void dispose() {
    // TODO: implement dispose
   _beautyFetcher.close();
  }


```

- BeautyBasePage 类

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/bloc_provider.dart';

import 'beauty_base_bloc.dart';
import 'beauty_bloc.dart';
import 'beauty_model.dart';

class BeautyBasePage extends StatefulWidget {
  @override
  _BeautyBasePageState createState() => _BeautyBasePageState();
}

class _BeautyBasePageState extends State<BeautyBasePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //拿到 BeautyBaseBloc 实例
    BeautyBaseBloc _bloc= BlocProvider.of<BeautyBaseBloc>(context);
    //获取网络数据
    _bloc.fetchBeauties();

    return Scaffold(
      appBar: AppBar(
        title: Text("BeautyPage"),
      ),
      body: Container(
          child: StreamBuilder(
              stream: _bloc.beauties,
              builder: (context, AsyncSnapshot<List<BeautyModel>> snapshot) {
                if (snapshot.hasData) {
                  print('has data');
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            snapshot.data[index].url,
                            fit: BoxFit.fill,
                          ));
                    },
                    itemCount: snapshot.data.length,
                  );
                } else if (snapshot.hasError) {
                  return Text('Beauty snapshot error!');
                }
                return Text('Loading Beauty..');
              })),
    );
  }
}

```

- 同 InheritedWidget 一样，在父节点插入 BlocProvider

```dart
class BeautyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "BeautyBloc Demo",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      //插入 BlocProvider
      home: BlocProvider<BeautyBaseBloc>(
          child: BeautyBasePage(), bloc: new BeautyBaseBloc()),
    );
  }
}
```

至此我们通用的 BlocProvider 管理类也写完了，其中它有 InheritedWidget 所拥有的特点，也能在 widget 销毁的时候自动的关闭流。
