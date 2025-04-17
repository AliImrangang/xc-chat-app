import 'package:chat_app/core/theme.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showInputValues() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    print("Username : $username - Email : $email - Password : $password");
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
        'Register',
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
                  _buildTextInput('Username', Icons.person, _usernameController),
                  SizedBox(height: 20),
                  _buildTextInput('Email', Icons.email, _emailController), 
                  SizedBox(height: 20),
                  _buildTextInput(
                    'Password',
                    Icons.lock,
                    _passwordController,
                    isPassword: true, 
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
