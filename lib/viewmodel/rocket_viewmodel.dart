import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/api_services.dart';
import '../repository/rocket_repository.dart';
import '../data/models/rocket_model.dart';

final rocketRepositoryProvider = Provider((ref) => RocketRepository(apiService: ApiService()));
class RocketNotifier extends StateNotifier<AsyncValue<List<Rocket>>> {
  RocketNotifier(this.ref) : super(const AsyncLoading());

  final Ref ref;
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchRockets({bool isInitialLoad = false}) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      final rockets = await ref.read(rocketRepositoryProvider).getRockets(limit: _limit, offset: _offset);
      if (rockets.isEmpty) {
        _hasMore = false;
      } else {
        final currentState = state.value ?? [];
        state = AsyncData([...currentState, ...rockets]);
        _offset += _limit;
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
    _isLoading = false;
  }
}

final rocketProvider = StateNotifierProvider<RocketNotifier, AsyncValue<List<Rocket>>>((ref) {
  final notifier = RocketNotifier(ref);
  notifier.fetchRockets(isInitialLoad: true);
  return notifier;
});
final rocketDetailsProvider = FutureProvider.family<Rocket, String>((ref, id) async {
  return ref.read(rocketRepositoryProvider).getRocketDetails(id);
});
