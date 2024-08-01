import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/auth.dart';
import 'package:shops_app/providers/cart.dart';
import 'package:shops_app/providers/orders.dart';
import 'package:shops_app/screens/auth_screen.dart';
import 'package:shops_app/screens/cart_screen.dart';
import 'package:shops_app/screens/edit_product_screen.dart';
import 'package:shops_app/screens/orders_screen.dart';
import 'package:shops_app/screens/product_detail_screen.dart';
import 'package:shops_app/screens/products_overview_screen.dart';
import 'package:shops_app/screens/splash_screen.dart';
import 'package:shops_app/screens/user_products_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
      value: Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
      create: (ctx) => Products('', [], ''),
      update: (ctx, auth, previousProducts) => Products(auth.token.toString(), previousProducts == null ? [] : previousProducts.items, auth.userId.toString()),
      ),
      ChangeNotifierProvider.value(
      value: Cart(),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
      create: (ctx) => Orders('', [],''),
      update: (ctx, auth, previousOrders) => Orders(auth.token.toString(), previousOrders == null ? [] : previousOrders.orders, auth.userId.toString()),
      )
    ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          hintColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
            }
          )
        ),
        home: auth.isAuth 
        ? const ProductsOverviewScreen() 
        : FutureBuilder(
          future: auth.tryAutoLogin(), 
          builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting 
          ? const SplashScreen() 
          :const AuthScreen()),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          AuthScreen.routeName: (ctx) => const AuthScreen(),
        },
      ),
        ) 
    );
  }
}
