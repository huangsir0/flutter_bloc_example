import 'package:rxdart/rxdart.dart';

import 'dog_model.dart';
import 'respository.dart';

class DogBloc{
  final _repository = Repository();
  final _dogFetcher = PublishSubject<Dog>();

  Observable<Dog> get dog =>_dogFetcher.stream;


  fetchDog() async{
    Dog itemModel=await _repository.fetchDog();
    _dogFetcher.sink.add(itemModel);
  }


  dispose(){
    _dogFetcher?.close();
  }
}