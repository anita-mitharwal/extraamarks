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

    when(mockRepository.getRockets()).thenAnswer((_) async => rockets);

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

    when(mockRepository.getRockets()).thenAnswer((_) async => rockets);

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

    await tester.tap(find.text('Falcon 9'));
    await tester.pumpAndSettle();

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

    expect(
        find.text('Failed to load rockets. Please try again.'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);

    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    verify(mockRepository.getRockets()).called(2);
  });
}
