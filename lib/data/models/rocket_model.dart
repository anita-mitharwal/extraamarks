import 'dart:convert';

List<Rocket> rocketFromJson(String str) =>
    List<Rocket>.from(json.decode(str).map((x) => Rocket.fromJson(x)));

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
      heightFeet: json["height"]["feet"].toDouble(),
      diameterFeet: json["diameter"]["feet"].toDouble(),
    );
  }
}
