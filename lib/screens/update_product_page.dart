import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:store/models/product_model.dart';
import 'package:store/services/update_product.dart';
import 'package:store/widgets/custom_button.dart';
import 'package:store/widgets/custom_text_field.dart';

class UpdateProductPage extends StatefulWidget {
  static String id = 'update product';

  const UpdateProductPage({Key? key}) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  String? productName, desc, image, price;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  late ProductModel product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    // تعبئة الحقول بالمعلومات القديمة
    nameController.text = product.title;
    descController.text = product.description;
    priceController.text = product.price.toString();
    imageController.text = product.image;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تعديل المنتج',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  controller: nameController,
                  labelText: 'اسم المنتج',
                  hintText: 'ادخل اسم المنتج',
                  onChanged: (data) => productName = data,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descController,
                  labelText: 'الوصف',
                  hintText: 'ادخل وصف المنتج',
                  onChanged: (data) => desc = data,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  labelText: 'السعر',
                  hintText: 'ادخل سعر المنتج',
                  inputType: TextInputType.number,
                  onChanged: (data) => price = data,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: imageController,
                  labelText: 'رابط الصورة',
                  hintText: 'ادخل رابط صورة المنتج',
                  onChanged: (data) => image = data,
                ),
                const SizedBox(height: 50),
                CustomButon(
                  text: 'تحديث',
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await updateProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم التحديث بنجاح')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('حدث خطأ: $e')),
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    await UpdateProductService().updateProduct(
      id: product.id,
      title: productName ?? product.title,
      price: price ?? product.price.toString(),
      desc: desc ?? product.description,
      image: image ?? product.image,
      category: product.category,
    );
  }
}
