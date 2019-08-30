import 'package:flutter/material.dart';

import 'dog_bloc.dart';
import 'dog_model.dart';

class DogPage extends StatefulWidget {
  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {

  final _dogBloc=DogBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dogBloc.fetchDog();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("DogPage"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _dogBloc.dog,
                builder: (context, AsyncSnapshot<Dog> snapshot) {
                  if (snapshot.hasData) {
                    print('Fms snapshot');
                    return Image.network(snapshot.data.message);
                  } else if (snapshot.hasError) {
                    return Text('Dog snapshot error!');
                  }
                  return Text('Loading dog..');
                })
          ],
        ),
      ),
    );
  }
}
