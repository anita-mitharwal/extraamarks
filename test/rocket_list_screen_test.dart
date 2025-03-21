import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

void main() {
  late MockRocketRepository mockRepository;

  setUp(() {
    mockRepository = MockRocketRepository();
  });

  test('Example test', () {
    when(mockRepository.getRockets()).thenAnswer((_) async => []);
    expect(mockRepository.getRockets(), isA<Future<List>>());
  });
}
