import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/network/network_info.dart';
import 'package:sdda_demo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sdda_demo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sdda_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sdda_demo/features/auth/domain/entities/user.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockLocal extends Mock implements AuthLocalDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockNetwork mockNetwork;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockNetwork = MockNetwork();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('login', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.login(email: 'a', password: 'b');

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna usuario stub con conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.login(email: 'a', password: 'b');

      expect(result.isRight(), true);
      result.map((user) => expect(user, isA<User>()));
    });
  });

  group('logout', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.logout();

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna Right cuando hay conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.logout();

      expect(result, const Right(null));
    });
  });

  group('register', () {
    test('retorna NetworkFailure sin conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.register(email: 'a', password: 'b', name: 'c');

      expect(result, const Left(NetworkFailure('Sin conexión a internet')));
    });

    test('retorna usuario stub con conexión', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repository.register(email: 'a', password: 'b', name: 'c');

      expect(result.isRight(), true);
    });
  });

  group('checkAuthStatus', () {
    test('retorna false por defecto (stub)', () async {
      final result = await repository.checkAuthStatus();
      expect(result, const Right(false));
    });
  });

  group('getCurrentUser', () {
    test('retorna Right(null) por defecto (stub)', () async {
      final result = await repository.getCurrentUser();
      expect(result, const Right(null));
    });
  });
}
