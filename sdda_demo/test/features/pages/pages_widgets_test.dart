import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sdda_demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:sdda_demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:sdda_demo/features/auth/presentation/pages/auth_page.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_bloc.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_event.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_state.dart';
import 'package:sdda_demo/features/demo/presentation/pages/demo_page.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_event.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_state.dart';
import 'package:sdda_demo/features/orders/presentation/pages/orders_page.dart';

class _MockDemoBloc extends MockBloc<DemoEvent, DemoState> implements DemoBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class _MockOrdersBloc extends MockBloc<OrdersEvent, OrdersState>
    implements OrdersBloc {}

void main() {
  group('Pages widgets', () {
    testWidgets('DemoPage muestra estados básicos', (tester) async {
      final bloc = _MockDemoBloc();
      final controller = StreamController<DemoState>.broadcast();
      addTearDown(controller.close);
      when(() => bloc.stream).thenAnswer((_) => controller.stream);
      when(() => bloc.state).thenReturn(const DemoInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DemoBloc>.value(
            value: bloc,
            child: const DemoPage(),
          ),
        ),
      );

      expect(find.text('Estado: Inicial'), findsOneWidget);
      controller.add(const DemoLoading());
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      controller.add(const DemoLoaded());
      await tester.pump();
      expect(find.text('Estado: Cargado'), findsOneWidget);
      controller.add(const DemoError('fallo'));
      await tester.pump();
      expect(find.text('Error: fallo'), findsOneWidget);
    });

    testWidgets('AuthPage muestra loading y error', (tester) async {
      final bloc = _MockAuthBloc();
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);
      when(() => bloc.stream).thenAnswer((_) => controller.stream);
      when(() => bloc.state).thenReturn(const AuthInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: bloc,
            child: const AuthPage(),
          ),
        ),
      );

      expect(find.text('Inicial'), findsOneWidget);
      controller.add(const AuthLoading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      controller.add(const AuthError('oops'));
      await tester.pump();
      expect(find.text('oops'), findsOneWidget);
    });

    testWidgets('OrdersPage muestra loaded', (tester) async {
      final bloc = _MockOrdersBloc();
      final controller = StreamController<OrdersState>.broadcast();
      addTearDown(controller.close);
      when(() => bloc.stream).thenAnswer((_) => controller.stream);
      when(() => bloc.state).thenReturn(const OrdersInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<OrdersBloc>.value(
            value: bloc,
            child: const OrdersPage(),
          ),
        ),
      );

      expect(find.text('Inicial'), findsOneWidget);
      controller.add(const OrdersLoading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      controller.add(const OrdersLoaded());
      await tester.pump();
      expect(find.text('Cargado'), findsOneWidget);
    });
  });
}
