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
