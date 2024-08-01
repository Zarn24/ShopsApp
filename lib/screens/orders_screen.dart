import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/orders.dart' show Orders;
import 'package:shops_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders-screen';
  const OrdersScreen({super.key});

  @override
Widget build(BuildContext context) {
  // final orderData = Provider.of<Orders>(context);
  return Scaffold(
    appBar: AppBar(
      title: const Text('Your Orders'), 
    ),
    drawer: const AppDrawer(),
    body: FutureBuilder(
      future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred!: ${snapshot.error}'),
          );
        } else {
          return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
            itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            itemCount: orderData.orders.length,
          ),
          );
        }
      },
    ),
  );
}
}