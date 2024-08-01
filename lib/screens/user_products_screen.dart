import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/products.dart';
import 'package:shops_app/screens/edit_product_screen.dart';
import 'package:shops_app/widgets/app_drawer.dart';
import 'package:shops_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';

  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {
      // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting 
        ? const Center(
          child: CircularProgressIndicator(),
        ) 
        :RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      title: productsData.items[i].title, 
                      imageUrl: productsData.items[i].imageUrl,
                      id: productsData.items[i].id),
                  ],
                ),
                ),
            ),
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add,
          color: Colors.white,
          size: 40,),),
    );
  }
}