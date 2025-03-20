import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Import generated mock

void main() {
  late MockRocketRepository mockRepository; // Use the generated mock class

  setUp(() {
    mockRepository = MockRocketRepository();
  });

  test('Example test', () {
    when(mockRepository.getRockets()).thenAnswer((_) async => []);
    expect(mockRepository.getRockets(), isA<Future<List>>());
  });
}
