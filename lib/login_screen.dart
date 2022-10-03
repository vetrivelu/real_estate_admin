import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:real_estate_admin/Providers/session.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      home: SignInScreen(
        showAuthActionSwitch: false,
        auth: AppSession().firbaseAuth,
        providerConfigs: const [
          EmailProviderConfiguration(),
        ],
      ),
    );
  }
}
