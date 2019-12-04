
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




}