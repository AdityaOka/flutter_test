import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
// API docs: https://dummyjson.com/docs/products#products-search

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Store(title: 'Interview Store'),
    );
  }
}

class Store extends StatefulWidget {
  const Store({super.key, required this.title});
  final String title;

  @override
  State<Store> createState() => _StorePage();
}

class _StorePage extends State<Store> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: TextButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  onPressed: null,
                ),
                labelText: 'Search product name',
                hintText: 'Search product name',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ProductCard(
                  image: 'https://dummyimage.com/200x200/000/fff',
                  title: 'Product 1',
                  price: 100.0,
                  onPressed: () {},
                ),
                ProductCard(
                  image: 'https://dummyimage.com/200x200/ccc/000',
                  title: 'Product 2',
                  price: 200.0,
                  onPressed: () {},
                ),
                ProductCard(
                  image: 'https://dummyimage.com/200x200/000/fff',
                  title: 'Product 1',
                  price: 100.0,
                  onPressed: () {},
                ),
                ProductCard(
                  image: 'https://dummyimage.com/200x200/ccc/000',
                  title: 'Product 2',
                  price: 200.0,
                  onPressed: () {},
                ),
                ProductCard(
                  image: 'https://dummyimage.com/200x200/000/fff',
                  title: 'Product 1',
                  price: 100.0,
                  onPressed: () {},
                ),
                ProductCard(
                  image: 'https://dummyimage.com/200x200/ccc/000',
                  title: 'Product 2',
                  price: 200.0,
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.onPressed,
    this.isAdded = false,
  });
  final String image;
  final String title;
  final double price;
  final bool isAdded;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card.outlined(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(image),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                    Text('\$$price'),
                    FilledButton(
                      onPressed: onPressed,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          isAdded
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: Text(isAdded ? 'Remove' : 'Add to Cart'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String image;
  final String title;
  final double price;

  const Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['thumbnail'],
        title = json['title'],
        price = json['price'];
}
