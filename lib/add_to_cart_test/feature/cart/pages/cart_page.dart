import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/cart/bloc/cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final product = state.items[index];
              return Card(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Product name: ${product.product.name}"),
                          const SizedBox(height: 5),
                          Text(
                            "Product desc: ${product.product.description}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text("${product.qty} шт")
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
