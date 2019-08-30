
import 'package:flutter_bloc_example/movie_bloc_example/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'movieitem_model.dart';

class MoviesBloc{

  final _repository=Repository();
  final _moviesFetcher = PublishSubject<MovieItemModel>();

  Observable<MovieItemModel> get allMovies=>_moviesFetcher.stream;

  fetchAllMovies() async{
  MovieItemModel itemModel =await _repository.fetchAllMovies();
  _moviesFetcher.sink.add(itemModel);
  }


  dispose(){
    _moviesFetcher.close();
  }


}