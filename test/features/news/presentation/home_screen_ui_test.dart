import 'package:Informed/features/news/bloc/news_bloc.dart';
import 'package:Informed/features/news/domain/news_entity.dart';
import 'package:Informed/features/news/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shimmer/shimmer.dart';

import 'home_screen_ui_test.mocks.dart';

// Generate mocks
@GenerateMocks([NewsBloc])
void main() {
  late MockNewsBloc mockNewsBloc;

  setUp(() {
    mockNewsBloc = MockNewsBloc();

    // Provide dummy values for abstract NewsState class
    provideDummy<NewsState>(NewsInitial());
  });

  final testArticle = NewsEntity(
    sourceName: 'Test Source',
    author: 'Test Author',
    title: 'Test Title',
    description: 'Test Description',
    url: 'https://test.com',
    urlToImage: 'https://test.com/image.jpg',
    publishedAt: DateTime.now(),
    content: 'Test Content',
    sourceId: '',
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<NewsBloc>(
        create: (context) => mockNewsBloc,
        child: HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should show loading shimmer when state is CountryNewsLoading',
        (WidgetTester tester) async {
      // arrange
      when(mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(CountryNewsLoading()));
      when(mockNewsBloc.state).thenReturn(CountryNewsLoading());
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      // Just pump once to render the loading state
      await tester.pump();

      // assert
      expect(find.byType(Card), findsWidgets);
      // Find Shimmer widget specifically
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('should show news list when state is CountryNewsLoaded',
        (WidgetTester tester) async {
      // arrange
      final List<NewsEntity> testArticles = [testArticle];
      when(mockNewsBloc.stream).thenAnswer(
          (_) => Stream.value(CountryNewsLoaded(news: testArticles)));
      when(mockNewsBloc.state)
          .thenReturn(CountryNewsLoaded(news: testArticles));
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Source'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
    });

    testWidgets('should show error message when state is CountryNewsError',
        (WidgetTester tester) async {
      // arrange
      const errorMessage = 'Something went wrong';
      when(mockNewsBloc.stream).thenAnswer(
          (_) => Stream.value(CountryNewsError(errorMessage: errorMessage)));
      when(mockNewsBloc.state)
          .thenReturn(CountryNewsError(errorMessage: errorMessage));
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should trigger search when search button is tapped',
        (WidgetTester tester) async {
      // arrange
      when(mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsInitial()));
      when(mockNewsBloc.state).thenReturn(NewsInitial());
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Enter text and tap search
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // assert
      verify(mockNewsBloc.add(GetQueryNewsEvent(query: 'test query')))
          .called(1);
    });

    testWidgets('should trigger search when text is submitted',
        (WidgetTester tester) async {
      // arrange
      when(mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsInitial()));
      when(mockNewsBloc.state).thenReturn(NewsInitial());
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Enter and submit text
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // assert
      verify(mockNewsBloc.add(GetQueryNewsEvent(query: 'test query')))
          .called(1);
    });

    testWidgets('should trigger country-wise news when country is selected',
        (WidgetTester tester) async {
      // arrange
      when(mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsInitial()));
      when(mockNewsBloc.state).thenReturn(NewsInitial());
      when(mockNewsBloc.country).thenReturn('all');

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump();

      await tester.tap(find.text('US   🇺🇸').last);
      await tester.pump();

      // assert
      verify(mockNewsBloc
              .add(GetCountryWiseNewsEvent(country: 'us', category: '')))
          .called(1);
    });
  });
}
