import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/cart.dart';
import 'package:shops_app/providers/orders.dart';
import '../widgets/cart_item.dart' as cartItem;

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                  const Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => cartItem.CartItem(
                id: cart.items.values.toList()[i].id, 
                title: cart.items.values.toList()[i].title, 
                quantity: cart.items.values.toList()[i].quantity, 
                price: cart.items.values.toList()[i].price,
                productId: cart.items.keys.toList()[i],
                ),
              itemCount: cart.items.length,
              ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null : () async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
      setState(() {
        _isLoading = false;
      });
      widget.cart.clear();
    }, child: _isLoading ? const Center(child: CircularProgressIndicator(),) : Text('ORDER NOW',
    style: TextStyle(
      color: Theme.of(context).primaryColor,
    ),
    ));
  }
}