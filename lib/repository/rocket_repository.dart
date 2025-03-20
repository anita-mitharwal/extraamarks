import '../data/models/rocket_model.dart';
import '../data/services/api_services.dart';

class RocketRepository {
  final ApiService apiService;

  RocketRepository({required this.apiService});

  // Method to fetch a paginated list of rockets
  Future<List<Rocket>> getRockets({int limit = 10, int offset = 0}) async {
    return await apiService.fetchRockets(limit: limit, offset: offset);
  }

  // ✅ Method to fetch rocket details using the rocket ID
  Future<Rocket> getRocketDetails(String id) async {
    return await apiService.fetchRocketDetails(id);
  }
}
