import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';

class PayPage extends StatefulWidget {
  final List<ProductModel> cartProducts;

  const PayPage({Key? key, required this.cartProducts}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late Map<ProductModel, int> productCountMap;

  @override
  void initState() {
    super.initState();
    _buildProductCountMap();
  }

  void _buildProductCountMap() {
    productCountMap = {};
    for (var product in widget.cartProducts) {
      productCountMap[product] = (productCountMap[product] ?? 0) + 1;
    }
  }

  void _removeOne(ProductModel product) {
    setState(() {
      if (productCountMap.containsKey(product)) {
        int count = productCountMap[product]!;
        if (count > 1) {
          productCountMap[product] = count - 1;
        } else {
          productCountMap.remove(product);
        }

        widget.cartProducts.clear();
        productCountMap.forEach((prod, qty) {
          for (int i = 0; i < qty; i++) {
            widget.cartProducts.add(prod);
          }
        });
      }
    });
  }

  double get totalPrice {
    double total = 0;
    productCountMap.forEach((product, count) {
      final price = product.price is String
          ? double.tryParse(product.price) ?? 0
          : (product.price is int
              ? product.price.toDouble()
              : product.price as double);
      total += price * count;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cartIsEmpty = productCountMap.isEmpty;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.cartProducts);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صفحة المشتريات'),
          centerTitle: true,
        ),
        body: cartIsEmpty
            ? const Center(child: Text('لم تضف أي منتج بعد.'))
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: productCountMap.entries.map((entry) {
                        final product = entry.key;
                        final quantity = entry.value;
                        return ListTile(
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                          title: Text(product.title),
                          subtitle: Text('السعر: \$${product.price}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('الكمية: $quantity'),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () => _removeOne(product),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المجموع: \$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('تم الدفع'),
                                content:
                                    const Text('شكراً لك على عملية الشراء!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // إغلاق الـ Dialog
                                      Navigator.pop(
                                          context,
                                          widget
                                              .cartProducts); // إغلاق صفحة الدفع وارجاع السلة
                                    },
                                    child: const Text('حسناً'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('ادفع الآن'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
