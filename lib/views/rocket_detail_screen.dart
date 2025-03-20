import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/rocket_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';


class RocketDetailScreen extends ConsumerWidget {
  final String rocketId;

  const RocketDetailScreen({Key? key, required this.rocketId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rocketDetails = ref.watch(rocketDetailsProvider(rocketId));

    return Scaffold(
      appBar: AppBar(title: Text("Rocket Details")),
      body: rocketDetails.when(
        data: (rocket) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rocket.name, style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Active: ${rocket.active ? "Yes" : "No"}"),
                Text("Cost per Launch: \$${rocket.costPerLaunch}"),
                Text("Success Rate: ${rocket.successRatePct}%"),
                Text("Height: ${rocket.heightFeet} ft"),
                Text("Diameter: ${rocket.diameterFeet} ft"),
                SizedBox(height: 10),
                Text("Description: ${rocket.description}"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _launchURL(rocket.wikipedia),
                  child: Text("More Info on Wikipedia"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: rocket.flickrImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(rocket.flickrImages[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text("Failed to load rocket details")),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}

