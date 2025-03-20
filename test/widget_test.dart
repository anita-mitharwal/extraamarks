import 'package:extraaedge_task/viewmodel/rocket_viewmodel.dart';
import 'package:extraaedge_task/views/rocket_detail_screen.dart';
import 'package:extraaedge_task/views/rocket_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:extraaedge_task/data/models/rocket_model.dart';
import 'mock_rocket_notifier.dart';
import 'mocks.mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  late MockRocketRepository mockRepository;

  setUp(() {
    mockRepository = MockRocketRepository();
  });

  testWidgets('Displays loading indicator initially', (WidgetTester tester) async {
    when(mockRepository.getRockets()).thenAnswer((_) async => Future.value([]));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: RocketListScreen()),
      ),);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Displays rocket list when data is available', (WidgetTester tester) async {
    final rockets = [
      Rocket(
        id: '1',
        name: 'Falcon 9',
        country: 'USA',
        engines: 9,
        flickrImages: [],
        active: true,
        costPerLaunch: 50000000,
        successRatePct: 98,
        description: 'Reusable rocket by SpaceX',
        wikipedia: '',
        heightFeet: 229.6,
        diameterFeet: 12.0,
      ),
    ];

    // ✅ Mock API call
    when(mockRepository.getRockets()).thenAnswer((_) async => rockets);

    // ✅ Override the provider with a mock notifier
    final mockNotifier = RocketNotifier(mockRepository as Ref<Object?>)..fetchRockets();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          rocketProvider.overrideWith((ref) => mockNotifier),
        ],
        child: const MaterialApp(home: RocketListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // ✅ Verify data display
    expect(find.text('Falcon 9'), findsOneWidget);
    expect(find.text('USA - 9 engines'), findsOneWidget);
  });


  testWidgets('Tapping on a rocket navigates to details page', (WidgetTester tester) async {
    final rockets = [
      Rocket(
        id: '1',
        name: 'Falcon 9',
        country: 'USA',
        engines: 9,
        flickrImages: [],
        active: true,
        costPerLaunch: 50000000,
        successRatePct: 98,
        description: 'Reusable rocket by SpaceX',
        wikipedia: '',
        heightFeet: 229.6,
        diameterFeet: 12.0,
      ),
    ];

    // ✅ Mock API call
    when(mockRepository.getRockets()).thenAnswer((_) async => rockets);

    // ✅ Use MockRocketNotifier
    final mockNotifier = MockRocketNotifier(mockRepository);
    await mockNotifier.fetchRockets();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          rocketProvider.overrideWith((ref) => mockNotifier),
        ],
        child: const MaterialApp(home: RocketListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // ✅ Tap on the first rocket
    await tester.tap(find.text('Falcon 9'));
    await tester.pumpAndSettle();

    // ✅ Verify if the detail screen is displayed
    expect(find.byType(RocketDetailScreen), findsOneWidget);
    expect(find.text('Falcon 9'), findsWidgets);
    expect(find.text('Reusable rocket by SpaceX'), findsWidgets);
  });

  testWidgets(
      'Displays error message and shows Try Again button on API failure', (
      WidgetTester tester) async {
    when(mockRepository.getRockets()).thenThrow(Exception('API Error'));

    await tester.pumpWidget(MaterialApp(home: RocketListScreen()));
    await tester.pumpAndSettle();

    // Check for error message and button
    expect(
        find.text('Failed to load rockets. Please try again.'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);

    // Tap on the Try Again button
    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    // Verify API called twice (initial call + retry)
    verify(mockRepository.getRockets()).called(2);
  });
}
