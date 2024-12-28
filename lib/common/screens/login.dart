import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    getLastSessionUserName();
  }

  void getLastSessionUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loginIdController.text = prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Watch the selectedLanguage from authProvider (in case you want to display it elsewhere)
    final selectedLanguage =
        ref.watch(authProvider.select((state) => state.selectedLanguage));

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/tb_login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildLoginContainer(selectedLanguage),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: _buildLanguageSelector(selectedLanguage),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContainer(String selectedLanguage) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth < 500 ? screenWidth * 0.9 : 400;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(height: 30),
            _buildLoginIdField(),
            const SizedBox(height: 15),
            _buildPasswordField(),
            const SizedBox(height: 30),
            _buildLoginButton(selectedLanguage),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/gstb_logo.png',
      height: 80,
    );
  }

  Widget _buildLoginIdField() {
    return TextFormField(
      controller: _loginIdController,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Login ID',
        labelStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Login ID';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            color: ColorPicker.formIconColor,
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLanguageSelector(String selectedLanguage) {
    TextStyle unselectedStyle =
        const TextStyle(fontSize: 18, color: Colors.white70);
    TextStyle selectedStyle = const TextStyle(
        fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold);

    return Row(
      children: [
        const Icon(Icons.language, size: 30, color: Colors.white),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedLanguage = 'ar';
            });
          },
          child: Text(
            'Arabic',
            style: _selectedLanguage == 'ar' ? selectedStyle : unselectedStyle,
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedLanguage = 'en';
            });
          },
          child: Text(
            'English',
            style: _selectedLanguage == 'en' ? selectedStyle : unselectedStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(String selectedLanguage) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final authNotifier = ref.read(authProvider.notifier);
              await authNotifier.login(_loginIdController.text,
                  _passwordController.text, _selectedLanguage);
            }
          },
          child: const Text(
            'LOGIN',
          ),
        ),
      ),
    );
  }
}
