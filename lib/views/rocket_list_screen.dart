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
      body: rocketsState.when(
        data: (rockets) {
          if (rockets.isEmpty) {
            return const Center(child: Text(noDataMessage));
          }
          return ListView.builder(
            itemCount: rockets.length,
            itemBuilder: (context, index) {
              final rocket = rockets[index];
              return ListTile(
                leading: Image.network(
                  rocket.flickrImages.isNotEmpty
                      ? rocket.flickrImages[0]
                      : placeholderImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(rocket.name),
                subtitle: Text("${rocket.country} - ${rocket.engines} engines"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RocketDetailScreen(rocketId: rocket.id),
                    ),
                  );
                },
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
    );
  }
}
