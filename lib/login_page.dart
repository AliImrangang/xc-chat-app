import 'package:flutter/material.dart';

import 'core/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showInputValues() {
    String email = _emailController.text;
    String password = _passwordController.text;

    print("Email : $email - Password : $password");
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _showInputValues,
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultColors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 40),
      ),
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextInput('Email', Icons.email, _emailController), // Corrected icon
                  SizedBox(height: 20),
                  _buildTextInput(
                    'Password',
                    Icons.lock,
                    _passwordController,
                    isPassword: true, // Enable password masking
                  ),
                  SizedBox(height: 20),
                  _buildRegisterButton(),
                  SizedBox(height: 20,),
                  _buildLoginPrompt(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoginPrompt() {
  return Center(
    child: GestureDetector(
      onTap: () {},
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: "Login",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildTextInput(
    String hint,
    IconData icon,
    TextEditingController usernameController, {
      bool isPassword = false,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: DefaultColors.sentMessageInput,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: usernameController,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}