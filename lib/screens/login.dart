import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/sign-up.dart';

class Login extends StatefulWidget {
  static String id = 'Login';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isChecked = false;
  bool _obscureText = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // متغيرات لتخزين رسائل الخطأ لكل حقل
  String? emailError;
  String? passwordError;

  Future<void> loginUser() async {
    // إزالة رسائل الخطأ السابقة قبل التحقق
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // تسجيل الدخول ناجح
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            emailError = 'المستخدم غير موجود.';
            emailController.clear();
            break;
          case 'wrong-password':
            passwordError = 'كلمة المرور غير صحيحة.';
            passwordController.clear();
            break;
          case 'invalid-email':
            emailError = 'البريد الإلكتروني غير صالح.';
            emailController.clear();
            break;
          default:
            emailError = 'حدث خطأ: ${e.message}';
        }
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/تصميم-متجر-إلكتروني.jpg',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(200, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Bitter',
                          ),
                        ),
                        const SizedBox(height: 30),

                        // رابط التسجيل
                        RichText(
                          text: TextSpan(
                            text: 'لا تملك حساب؟ ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'إنشاء حساب',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, SignUp.id);
                                  },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // حقل البريد الإلكتروني مع إظهار الخطأ تحته
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email),
                            border: const OutlineInputBorder(),
                            errorText: emailError,
                          ),
                          validator: (value) =>
                              value != null && value.contains('@')
                                  ? null
                                  : 'أدخل بريدًا صالحًا',
                        ),

                        const SizedBox(height: 20),

                        // حقل كلمة المرور مع إظهار الخطأ تحته
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            errorText: passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) =>
                              value != null && value.length >= 6
                                  ? null
                                  : 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              'تذكرني',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  // يمكنك إضافة خاصية استعادة كلمة المرور هنا
                                },
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 91, 102, 91),
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: loginUser,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
