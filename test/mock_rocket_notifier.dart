import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:extraaedge_task/data/models/rocket_model.dart';
import 'package:extraaedge_task/repository/rocket_repository.dart';
import 'package:extraaedge_task/viewmodel/rocket_viewmodel.dart';

class MockRocketNotifier extends RocketNotifier {
  final RocketRepository mockRepository;

  MockRocketNotifier(this.mockRepository) : super(mockRepository as Ref<Object?>);

  @override
  Future<void> fetchRockets({bool isInitialLoad = false}) async {
    try {
      final rockets = await mockRepository.getRockets();
      state = rockets as AsyncValue<List<Rocket>>;
    } catch (e) {
      state = [] as AsyncValue<List<Rocket>>;
      print("Error: $e");
    }
  }
}
