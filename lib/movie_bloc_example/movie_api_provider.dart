import 'package:http/http.dart';

import 'movieitem_model.dart';
import 'dart:convert';
class MovieApiProvider{

  Client client=Client();
  final apiKey='a0791f8a1f524d5f78230d1153e145e8';

  Future<MovieItemModel> fetchMoviesList() async{
    final response =await client.get('http://api.themoviedb.org/3/movie/popular?api_key=$apiKey');

    if(response.statusCode==200){
      return MovieItemModel.fromJson(json.decode(response.body));
    }else{
      throw  Exception('Failed to load posts!');
    }
  }
}