
import 'dog_api_provider.dart';
import 'dog_model.dart';

class Repository{

  final dogApiProvider = DogApiProvider();

  Future<Dog> fetchDog()=>dogApiProvider.fetchDog();
}