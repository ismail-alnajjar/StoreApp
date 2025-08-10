import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/helper/AppDarkTheme.dart';
import 'package:store/helper/themeControler.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/login.dart';
import 'package:store/screens/settingsPage.dart';
import 'package:store/screens/sign-up.dart';
import 'package:store/screens/update_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: AppDarkTheme.theme,
          themeMode: currentMode,
          routes: {
            SignUp.id: (context) => const SignUp(),
            Login.id: (context) => const Login(),
            HomePage.id: (context) => const HomePage(),
            UpdateProductPage.id: (context) => const UpdateProductPage(),
            SettingPage.id: (context) => const SettingPage(),
            // ملاحظة: يمكن إضافة PayPage هنا ولكن لأننا نمرر قائمة عبر constructor، نستخدم Navigator.push بالـ MaterialPageRoute
          },
          initialRoute: Login.id,
        );
      },
    );
  }
}
