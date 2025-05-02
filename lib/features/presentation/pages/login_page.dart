import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input_fields.dart';
import '../widgets/login_prompt.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
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
                  AuthInputFields(
                    hint: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  AuthInputFields(
                    hint: 'Password',
                    icon: Icons.lock,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  BlocConsumer<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return AuthButton(text: 'Login', onPressed: _onLogin);
                    },
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/conversationPage',
                          (route) => false,
                        );
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  LoginPrompt(
                    title: "Don't have an account?",
                    subtitle: 'Click here to register',
                    onTap: () {
                      print("Attempting to navigate to register screen");
                      Navigator.pushNamed(context, '/register').then((_) {
                        print("Navigation completed or popped");
                      }).catchError((error) {
                        print("Navigation error: $error");
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
