import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
          // appBar: AppBar(
          //   title: Text(loadedProduct.title),
          // ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(loadedProduct.title,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  ),
                  background: Hero(
                    tag: loadedProduct.id,
                    child: Image.network(loadedProduct.imageUrl,
                    fit: BoxFit.cover,),
                  ),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate([
                 const SizedBox(
          height: 10,
        ),
        Text('\$${loadedProduct.price}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Text(loadedProduct.description,
          textAlign: TextAlign.center,
          softWrap: true,
          ),
        ),
        const SizedBox(height: 800,)
              ])),
            ],
          )
    );
  }
}





        