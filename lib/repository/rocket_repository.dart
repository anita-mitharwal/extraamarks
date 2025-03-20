import '../data/models/rocket_model.dart';
import '../data/local/db_helper.dart';
import '../data/services/api_services.dart';

class RocketRepository {
  final ApiService apiService;
  final DBHelper dbHelper = DBHelper();
  RocketRepository({required this.apiService});
  Future<List<Rocket>> getRockets({int limit = 10, int offset = 0}) async {
    try {
      final localData = await dbHelper.getRockets();
      if (localData.isNotEmpty) {
        return localData.skip(offset).take(limit).toList();
      }

      final rockets = await apiService.fetchRockets();
      for (var rocket in rockets) {
        await dbHelper.insertRocket(rocket);
      }

      return rockets.skip(offset).take(limit).toList();
    } catch (e) {
      throw Exception("Failed to load rockets: $e");
    }
  }

  Future<Rocket> getRocketDetails(String id) async {
    try {

      final localRocket = await dbHelper.getRocketById(id);
      if (localRocket != null) {
        return localRocket;
      }

      final rocket = await apiService.fetchRocketDetails(id);
      await dbHelper.insertRocket(rocket);
      return rocket;
    } catch (e) {
      throw Exception("Failed to load rocket details: $e");
    }
  }
}
