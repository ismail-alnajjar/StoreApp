import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/update_product_page.dart';

class CustomCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onAdd;

  const CustomCard({Key? key, required this.product, required this.onAdd})
      : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UpdateProductPage.id,
            arguments: widget.product);
      },
      child: SizedBox(
        height: 265, // زيادة 15 بيكسل عن الارتفاع السابق 250
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              bottom: -15, // لتوفير مساحة إضافية أسفل الكارد
              child: Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 80,
                      left: 14,
                      right: 14,
                      bottom: 27), // زيادة البادينج السفلي 15
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title.length > 6
                            ? widget.product.title.substring(0, 6)
                            : widget.product.title,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.image,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),

            // زر زائد (+) في أعلى اليمين فوق الكارد
            Positioned(
              top: 60,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  widget.onAdd();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 168, 190, 168),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
