import 'dart:convert';

List<Rocket> rocketFromJson(String str) =>
    List<Rocket>.from(json.decode(str).map((x) => Rocket.fromJson(x)));

String rocketToJson(List<Rocket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rocket {
  final String id;
  final String name;
  final String country;
  final int engines;
  final List<String> flickrImages;
  final bool active;
  final int costPerLaunch;
  final int successRatePct;
  final String description;
  final String wikipedia;
  final double heightFeet;
  final double diameterFeet;

  Rocket({
    required this.id,
    required this.name,
    required this.country,
    required this.engines,
    required this.flickrImages,
    required this.active,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.description,
    required this.wikipedia,
    required this.heightFeet,
    required this.diameterFeet,
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json["id"],
      name: json["name"],
      country: json["country"],
      engines: json["engines"]["number"],
      flickrImages: List<String>.from(json["flickr_images"].map((x) => x)),
      active: json["active"],
      costPerLaunch: json["cost_per_launch"],
      successRatePct: json["success_rate_pct"],
      description: json["description"],
      wikipedia: json["wikipedia"],
      heightFeet: (json["height"]["feet"] ?? 0.0).toDouble(),
      diameterFeet: (json["diameter"]["feet"] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "country": country,
      "engines": engines,
      "flickr_images": flickrImages,
      "active": active,
      "cost_per_launch": costPerLaunch,
      "success_rate_pct": successRatePct,
      "description": description,
      "wikipedia": wikipedia,
      "height": {"feet": heightFeet},
      "diameter": {"feet": diameterFeet},
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'engines': engines,
      'flickrImages': flickrImages.join(','),
      'active': active ? 1 : 0,
      'costPerLaunch': costPerLaunch,
      'successRatePct': successRatePct,
      'description': description,
      'wikipedia': wikipedia,
      'heightFeet': heightFeet,
      'diameterFeet': diameterFeet,
    };
  }

  factory Rocket.fromMap(Map<String, dynamic> map) {
    return Rocket(
      id: map['id'],
      name: map['name'],
      country: map['country'],
      engines: map['engines'],
      flickrImages: (map['flickrImages'] as String).split(','),
      active: map['active'] == 1,
      costPerLaunch: map['costPerLaunch'],
      successRatePct: map['successRatePct'],
      description: map['description'],
      wikipedia: map['wikipedia'],
      heightFeet: map['heightFeet']?.toDouble() ?? 0.0,
      diameterFeet: map['diameterFeet']?.toDouble() ?? 0.0,
    );
  }
}
