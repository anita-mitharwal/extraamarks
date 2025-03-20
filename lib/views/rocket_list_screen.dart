import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utilis/constants.dart';
import '../viewmodel/rocket_viewmodel.dart';
import 'rocket_detail_screen.dart';

class RocketListScreen extends ConsumerStatefulWidget {
  const RocketListScreen({super.key});

  @override
  ConsumerState<RocketListScreen> createState() => _RocketListScreenState();
}

class _RocketListScreenState extends ConsumerState<RocketListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(rocketProvider.notifier).fetchRockets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rocketsState = ref.watch(rocketProvider);
    final isLoading = ref.read(rocketProvider.notifier).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: rocketsState.when(
        data: (rockets) {
          if (rockets.isEmpty) {
            return const Center(child: Text(noDataMessage));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: rockets.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == rockets.length) {
                return const Center(child: CircularProgressIndicator());
              }
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
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
