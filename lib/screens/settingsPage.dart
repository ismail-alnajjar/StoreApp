import 'package:flutter/material.dart';
import 'package:store/helper/themeControler.dart';
import 'package:store/screens/login.dart';

class SettingPage extends StatefulWidget {
  static String id = "settingPage";
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeNotifier,
            builder: (context, currentMode, _) {
              bool isDark = currentMode == ThemeMode.dark;
              return ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("الوضع الليلي"),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    ThemeController.toggleTheme(value);
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("تغيير اللغة"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تغيير اللغة'),
                  content: const Text('ميزة تغيير اللغة غير مفعلة حالياً.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("الإشعارات"),
            secondary: const Icon(Icons.notifications),
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("حول التطبيق"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'تطبيقي',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.store),
                children: const [
                  Text('هذا التطبيق مثال لصفحة إعدادات مع مزايا مختلفة.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("تسجيل الخروج"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تأكيد تسجيل الخروج'),
                  content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Login.id, (route) => false);
                      },
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
