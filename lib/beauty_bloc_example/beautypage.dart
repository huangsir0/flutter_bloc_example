import 'package:flutter/material.dart';

import 'beauty_bloc.dart';
import 'beauty_model.dart';

class BeautyPage extends StatefulWidget {
  @override
  _BeautyPageState createState() => _BeautyPageState();
}

class _BeautyPageState extends State<BeautyPage> {
  final _beautyBloc = BeautyBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _beautyBloc.fetchBeauties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BeautyPage"),
      ),
      body: Container(
          child: StreamBuilder(
              //监听流
              stream: _beautyBloc.beauties,
              builder: (context, AsyncSnapshot<List<BeautyModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            snapshot.data[index].url,
                            fit: BoxFit.fill,
                          ));
                    },
                    itemCount: snapshot.data.length,
                  );
                } else if (snapshot.hasError) {
                  return Text('Beauty snapshot error!');
                }
                return Text('Loading Beauties..');
              })),
    );
  }
}
