import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/orders_bloc.dart';
import '../bloc/orders_state.dart';

/// Página principal del feature Orders.
class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return switch (state) {
            OrdersInitial() => const Center(
              child: Text('Inicial'),
            ),
            OrdersLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            OrdersLoaded() => const Center(
              child: Text('Cargado'),
            ),
            OrdersError(:final message) => Center(
              child: Text(message),
            ),
          };
        },
      ),
    );
  }
}
