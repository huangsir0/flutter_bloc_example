import 'movie_api_provider.dart';
import 'movieitem_model.dart';

class Repository{
  final moviesApiProvider = MovieApiProvider();

  Future<MovieItemModel> fetchAllMovies() =>
      moviesApiProvider.fetchMoviesList();
}