import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20 + 110, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amouunt.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }, 
              icon:Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded ? min(widget.order.products.length * 20 + 10, 110) : 0,
              child: ListView(
                children: widget.order.products.map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  children: [
                    Text(prod.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    Text('${prod.quantity}x \$${prod.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey, 
                    ),
                    )
                  ],
                )).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}