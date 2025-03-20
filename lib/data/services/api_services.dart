import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rocket_model.dart';

class ApiService {
  static const String baseUrl = "https://api.spacexdata.com/v4/rockets";

  // ✅ Fetch Rocket List with Pagination
  Future<List<Rocket>> fetchRockets({int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final allRockets = rocketFromJson(response.body);
      return allRockets.skip(offset).take(limit).toList();
    } else {
      throw Exception("Failed to load rockets");
    }
  }

  // ✅ Fetch Rocket Details using Rocket ID
  Future<Rocket> fetchRocketDetails(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Rocket.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load rocket details for ID: $id");
    }
  }
}
