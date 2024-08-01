import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/auth.dart';
import 'package:shops_app/providers/cart.dart';
import 'package:shops_app/providers/product.dart';
import 'package:shops_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavoriteStatus(authData.token.toString(), authData.userId.toString());
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).hintColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();  
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Item Added to Cart.'),
                  action: SnackBarAction(label: 'UNDO', onPressed: () {
                    cart.deleteSingleItem(product.id);
                  }),
                  duration: const Duration(
                    seconds: 2,
                  ),
                  )
                );
              },
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).hintColor,
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product-placeholder.png'), 
              image: NetworkImage(product.imageUrl), 
              fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}
