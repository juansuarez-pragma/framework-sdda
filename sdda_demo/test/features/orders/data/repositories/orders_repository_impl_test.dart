import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/exceptions.dart';
import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/network/network_info.dart';
import 'package:sdda_demo/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:sdda_demo/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:sdda_demo/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:sdda_demo/features/orders/domain/entities/order.dart';
import 'package:sdda_demo/features/orders/domain/entities/order_item.dart';

class MockRemote extends Mock implements OrdersRemoteDataSource {}

class MockLocal extends Mock implements OrdersLocalDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

void main() {
  late OrdersRepositoryImpl repository;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockNetwork mockNetwork;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockNetwork = MockNetwork();
    repository = OrdersRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('createOrder', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.createOrder(items: const <OrderItem>[]);

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna Right con orden stub cuando hay conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.createOrder(items: const []);

      expect(result.isRight(), true);
    });
  });

  group('getOrder', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.getOrder(id: '1');

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna Right con orden stub cuando hay conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.getOrder(id: '1');

      expect(result.isRight(), true);
    });
  });

  group('cancelOrder', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.cancelOrder(id: '1');

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna Right cuando hay conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.cancelOrder(id: '1');

      expect(result, const Right(null));
    });
  });
}
