import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/cart/bloc/cart_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/cart/pages/cart_page.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/view/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeBloc>().add(const GetProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Badge(
                padding: const EdgeInsets.all(0),
                offset: const Offset(0, 0),
                label: Text("${state.items.length}"),
                isLabelVisible: state.items.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CartPage();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state) {
            case HomeLoading():
            case HomeError():
              return const Center(child: CircularProgressIndicator());
            case HomeLoaded():
              return ListView.builder(
                itemCount: state.product.length,
                itemBuilder: (context, index) {
                  final product = state.product[index];
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
                              Text("Product name: ${product.name}"),
                              const SizedBox(height: 5),
                              Text(
                                "Product desc: ${product.description}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<CartBloc>().add(AddToCart(product));
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
