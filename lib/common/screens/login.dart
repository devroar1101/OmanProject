import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/home.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String _selectedLanguage = 'English';
  TextEditingController _loginIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/tb_login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay to darken background
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildLoginContainer(context),
              ),
            ),
          ),
          // Language selector positioned at the bottom right
          Positioned(
            bottom: 30,
            right: 30,
            child: _buildLanguageSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContainer(BuildContext context) {
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
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(height: 30), // Spacing between logo and fields
            _buildLoginIdField(),
            const SizedBox(height: 15),
            _buildPasswordField(),
            const SizedBox(height: 30),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  // Logo Widget without Title
  Widget _buildLogo() {
    return Image.asset(
      'assets/gstb_logo.png',
      height: 80,
    );
  }

  // Login ID Field with validation
  Widget _buildLoginIdField() {
    return TextFormField(
      controller: _loginIdController,
      style: TextStyle(fontSize: 14), // Reduced font size
      decoration: InputDecoration(
        labelText: 'Login ID',
        labelStyle: TextStyle(fontSize: 14), // Reduced label font size
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

  // Password Field with visibility toggle and validation
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontSize: 14), // Reduced font size
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: 14), // Reduced label font size
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
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

  // Language Selector with global icon and full names
  Widget _buildLanguageSelector() {
    // Light color for unselected and white for selected
    TextStyle unselectedStyle = TextStyle(
        fontSize: 18, color: Colors.white70); // Light gray for unselected
    TextStyle selectedStyle = const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold); // White for selected

    return Row(
      children: [
        // Global Icon with White Color
        Icon(Icons.language, size: 30, color: Colors.white),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => setState(() => _selectedLanguage = 'Arabic'),
          child: Text(
            'Arabic',
            style:
                _selectedLanguage == 'Arabic' ? selectedStyle : unselectedStyle,
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => setState(() => _selectedLanguage = 'English'),
          child: Text(
            'English',
            style: _selectedLanguage == 'English'
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
      ],
    );
  }

  // Centered Login Button at Bottom
  Widget _buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Home(),
                ),
              );
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
