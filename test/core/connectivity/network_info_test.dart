import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/core/connection/network_info.dart';
import 'dart:async';

// Generate mock class
@GenerateMocks([Connectivity])
import 'network_info_test.mocks.dart';

void main() {
  group('Mocked Connectivity Tests', () {
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();

      // Initialize the mock method to return a default value
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none],
      );
    });

    test('Check WiFi Connectivity with Mock', () async {
      // Mock the return value to simulate WiFi connection
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.wifi]);
    });

    test('Check Mobile Data Connectivity with Mock', () async {
      // Mock the return value to simulate mobile data connection
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.mobile]);
    });

    test('Check No Connectivity with Mock', () async {
      // Mock the return value to simulate no connectivity
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.none]);
    });

    test('Check Connectivity Change Listener with Mock', () async {
      // Create a stream controller that emits lists of connectivity results
      final streamController = StreamController<List<ConnectivityResult>>();

      // Mock the connectivity change stream
      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => streamController.stream);

      // Add test values to the stream as lists
      streamController.add([ConnectivityResult.wifi]);
      streamController
          .add([ConnectivityResult.wifi, ConnectivityResult.mobile]);
      streamController.add([ConnectivityResult.none]);

      // Listen for connectivity changes and assert the values
      await expectLater(
        mockConnectivity.onConnectivityChanged,
        emitsInOrder([
          [ConnectivityResult.wifi],
          [ConnectivityResult.wifi, ConnectivityResult.mobile],
          [ConnectivityResult.none]
        ]),
      );

      // Clean up
      await streamController.close();
    });
  });

  group('Test connectivity on Network Info Implementation', () {
    late MockConnectivity mockConnectivity;
    late NetworkInfoImpl networkInfoImpl;

    setUp(() {
      mockConnectivity = MockConnectivity();
      networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
    });

    test('Should return true when connectivity result is wifi', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfoImpl.isConnected;

      expect(result, true);
    });

    test('Should return true when connectivity result is mobile', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      final result = await networkInfoImpl.isConnected;

      expect(result, true);
    });

    test('Should return false when connectivity result is only none', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      final result = await networkInfoImpl.isConnected;

      // Assert
      expect(result, false);
      verify(mockConnectivity.checkConnectivity());
    });

    test(
        'Should return true when multiple connectivity results include a valid connection',
        () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.none, ConnectivityResult.wifi]);

      // Act
      final result = await networkInfoImpl.isConnected;

      // Assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });
  });
}
