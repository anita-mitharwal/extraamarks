import '../utilis/constants.dart';
import '../widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/rocket_viewmodel.dart';
import 'rocket_detail_screen.dart';

class RocketListScreen extends ConsumerStatefulWidget {
  const RocketListScreen({super.key});

  @override
  ConsumerState<RocketListScreen> createState() => _RocketListScreenState();
}

class _RocketListScreenState extends ConsumerState<RocketListScreen> {
  Future<void> _fetchRockets() async {
    try {
      await ref.read(rocketProvider.notifier).fetchRockets(isInitialLoad: true);
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final rocketsState = ref.watch(rocketProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.black,
          ),


          Expanded(
            child: rocketsState.when(
              data: (rockets) {
                if (rockets.isEmpty) {
                  return const Center(child: Text(noDataMessage));
                }
                return ListView.separated(
                  itemCount: rockets.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final rocket = rockets[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RocketDetailScreen(rocketId: rocket.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Image.network(
                              rocket.flickrImages.isNotEmpty
                                  ? rocket.flickrImages[0]
                                  : placeholderImage,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 12),

                            Text(
                              rocket.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              rocket.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorWidgetWithRetry(
                errorMessage: error.toString(),
                onRetry: _fetchRockets,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
