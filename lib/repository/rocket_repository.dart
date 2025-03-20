import '../data/models/rocket_model.dart';
import '../data/local/db_helper.dart';
import '../data/services/api_services.dart';

class RocketRepository {
  final ApiService apiService;
  final DBHelper dbHelper = DBHelper();

  RocketRepository({required this.apiService});

  // ✅ Fetch Rockets with Caching
  Future<List<Rocket>> getRockets({int limit = 10, int offset = 0}) async {
    try {
      // Check if data exists in local DB
      final localData = await dbHelper.getRockets();
      if (localData.isNotEmpty) {
        print("Loaded from cache");
        return localData.skip(offset).take(limit).toList();
      }

      // Fetch from API if no data found
      final rockets = await apiService.fetchRockets();
      for (var rocket in rockets) {
        await dbHelper.insertRocket(rocket);
      }
      print("Loaded from API and cached");
      return rockets.skip(offset).take(limit).toList();
    } catch (e) {
      throw Exception("Failed to load rockets: $e");
    }
  }

  // ✅ Fetch Rocket Details with Caching
  Future<Rocket> getRocketDetails(String id) async {
    try {
      // Try fetching from local DB
      final localRocket = await dbHelper.getRocketById(id);
      if (localRocket != null) {
        print("Loaded rocket from cache");
        return localRocket;
      }

      // Fetch from API if not available locally
      final rocket = await apiService.fetchRocketDetails(id);
      await dbHelper.insertRocket(rocket);
      print("Loaded rocket from API and cached");
      return rocket;
    } catch (e) {
      throw Exception("Failed to load rocket details: $e");
    }
  }
}
