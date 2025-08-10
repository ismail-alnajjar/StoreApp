import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/CustomNotification.dart';
import 'package:store/screens/PayPage.dart';
import 'package:store/screens/SearchPage.dart';
import 'package:store/screens/settingsPage.dart';
import 'package:store/services/get_all_product_service.dart';
import 'package:store/widgets/Custom%20Bottom.dart';
import 'package:store/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<ProductModel> cart = [];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeBody(
        onAddToCart: (product) {
          setState(() {
            cart.add(product);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.title} تم إضافته إلى السلة')),
          );
        },
      ),
      const CustomSearch(),
      const NotificationPage(),
      const SettingPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  final updatedCart = await Navigator.push<List<ProductModel>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PayPage(cartProducts: cart),
                    ),
                  );
                  if (updatedCart != null) {
                    setState(() {
                      cart = updatedCart;
                    });
                  }
                },
                icon: Icon(
                  FontAwesomeIcons.shoppingBag,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'New Trend',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final void Function(ProductModel) onAddToCart;

  const HomeBody({Key? key, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<ProductModel>>(
        future: AllProductsService().getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            if (products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات'));
            }
            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 30,
                mainAxisSpacing: 25,
              ),
              itemBuilder: (context, index) {
                return CustomCard(
                  product: products[index],
                  onAdd: () => onAddToCart(products[index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ أثناء تحميل المنتجات:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
