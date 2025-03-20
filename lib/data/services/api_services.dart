import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rocket_model.dart';
import '../../utilis/constants.dart';

class ApiService {
  static const String baseUrl1 = baseUrl;
  Future<List<Rocket>> fetchRockets({int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse(baseUrl1));

    if (response.statusCode == 200) {
      final allRockets = rocketFromJson(response.body);
      return allRockets.skip(offset).take(limit).toList();
    } else {
      throw Exception("Failed to load rockets");
    }
  }

  Future<Rocket> fetchRocketDetails(String id) async {
    final response = await http.get(Uri.parse("$baseUrl1/$id"));

    if (response.statusCode == 200) {
      return Rocket.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load rocket details for ID: $id");
    }
  }
}
