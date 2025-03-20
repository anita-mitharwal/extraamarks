import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/rocket_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class RocketDetailScreen extends ConsumerWidget {
  final String rocketId;

  const RocketDetailScreen({super.key, required this.rocketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rocketDetails = ref.watch(rocketDetailsProvider(rocketId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rocket Details"),
        centerTitle: true,
      ),
      body: rocketDetails.when(
        data: (rocket) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text(
                    rocket.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Action-Value Alignment
                _buildInfoRow("Active:", rocket.active ? "Yes" : "No"),
                _buildInfoRow("Cost per Launch:", "\$${rocket.costPerLaunch}"),
                _buildInfoRow("Success Rate:", "${rocket.successRatePct}%"),
                _buildInfoRow("Height:", "${rocket.heightFeet} ft"),
                _buildInfoRow("Diameter:", "${rocket.diameterFeet} ft"),

                const SizedBox(height: 16),

                const Text(
                  "Description:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  rocket.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => _launchURL(rocket.wikipedia),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    "More Info on Wikipedia",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 300, //
                  child: PageView.builder(
                    itemCount: rocket.flickrImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          rocket.flickrImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
        const Center(child: Text("Failed to load rocket details")),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
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
