import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final title;
  final posterPath;
  final releaseDate;
  final overview;
  final id;
  DetailPage(
      this.title,
      this.posterPath,
      this.releaseDate,
      this.overview,
      this.id,
      );

  @override
  Widget build(BuildContext context) {
    print('o id e $id lancado em $releaseDate');
    if (title == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body:SingleChildScrollView(
        child:  Column(
          children: <Widget>[
            Center(child: Hero(tag:id
                , child: Image.network('https://image.tmdb.org/t/p/w185${posterPath}',
                  fit: BoxFit.cover,)),),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                releaseDate,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                overview,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
