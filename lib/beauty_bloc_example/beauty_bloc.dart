
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