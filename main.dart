import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  late Future<List<Product>> products;
  late TextEditingController _searchController;
  Map<int, bool> cart = {};
  double total = 0;

  void toggleCart(Product product) {
    setState(() {
      if (cart.containsKey(product.id)) {
        cart.remove(product.id);
        total -= product.price;
      } else {
        cart[product.id] = true;
        total += product.price;
      }
    });
  }

  void searchProducts(String query) {
    setState(() {
      products = fetchProducts(query);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    products = fetchProducts('');
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
                  onPressed: () => {
                    searchProducts(_searchController.text),
                  },
                ),
                labelText: 'Search product name',
                hintText: 'Search product name',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Offstage(
            offstage: cart.isEmpty,
            child: Text('Total: \$${total.toStringAsFixed(2)}'),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return ProductCard(
                        image: product.image,
                        title: product.title,
                        price: product.price,
                        isAdded: cart.containsKey(product.id),
                        onPressed: () => toggleCart(product),
                      );
                    },
                  );
                }
              },
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
              Expanded(
                child: Container(
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
                        ),
                        child: Text(isAdded ? 'Remove' : 'Add to Cart'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Product>> fetchProducts(String query) async {
  Response response = await dio.get('/products/search?q=$query');

  List<Product> products = response.data['products']
      .map<Product>((e) => Product.fromJson(e))
      .toList();
  return products;
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
