import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/products.dart';
import 'package:shops_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({super.key, required this.title, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
            }, icon: const Icon(Icons.edit), color: Theme.of(context).primaryColor,),
            IconButton(onPressed: () async {
              try{
                await Provider.of<Products>(context, listen: false).deleteProduct(id);
              } catch (error) {
                scaffold.showSnackBar(const SnackBar(content: Text('Deletion failed!', textAlign: TextAlign.center,)));
              }
              
            }, icon: const Icon(Icons.delete), color: Colors.red,),
          ],
        ),
      ),
    );
  }
}