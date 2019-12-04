import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'beauty_model.dart';

class NetApi {
  Client client = new Client();

  Future<List<BeautyModel>> fetchBeauties() async {
    print("Starting get beauties ..");
    List models = List();
    final response =
        await client.get("http://gank.io/api/data/福利/15/1");
    if (response.statusCode == 200) {
      models = json.decode(response.body)["results"];
      return models.map((model){
        return BeautyModel.fromJson(model);
      }).toList();
    } else {
      throw Exception('Failed to load dog');
    }
  }
}
