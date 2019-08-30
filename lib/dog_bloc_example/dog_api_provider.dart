import 'package:http/http.dart' show Client;

import 'dog_model.dart';

class DogApiProvider {
  Client client = new Client();

  Future<Dog> fetchDog() async {
    print("Starting fetch dog ..");
    final response =
        await client.get("https://dog.ceo/api/breeds/image/random");
    if (response.statusCode == 200) {
      return dogFromJson(response.body);
    } else {
      throw Exception('Failed to load dog');
    }
  }
}
