import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/movie_bloc_example/widget_movie_list.dart';

import 'detailpage.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  _callDetail(context,title,posterPath,releaseDate,overview,id){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return DetailPage(
        title,
        posterPath,
        releaseDate,
        overview,
        id,
      );
    }));
  }


  @override
  Widget build(BuildContext context) {
    return MovieList(_callDetail);
  }
}
