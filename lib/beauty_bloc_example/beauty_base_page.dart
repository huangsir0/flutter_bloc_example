import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/bloc_provider.dart';

import 'beauty_base_bloc.dart';
import 'beauty_bloc.dart';
import 'beauty_model.dart';

class BeautyBasePage extends StatefulWidget {
  @override
  _BeautyBasePageState createState() => _BeautyBasePageState();
}

class _BeautyBasePageState extends State<BeautyBasePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //拿到 BeautyBaseBloc 实例
    BeautyBaseBloc _bloc= BlocProvider.of<BeautyBaseBloc>(context);
    //获取网络数据
    _bloc.fetchBeauties();

    return Scaffold(
      appBar: AppBar(
        title: Text("BeautyPage"),
      ),
      body: Container(
          child: StreamBuilder(
              stream: _bloc.beauties,
              builder: (context, AsyncSnapshot<List<BeautyModel>> snapshot) {
                if (snapshot.hasData) {
                  print('has data');
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
                return Text('Loading Beauty..');
              })),
    );
  }
}
