import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/presentation/bloc/auth_state.dart';
import 'package:chat_app/features/presentation/widgets/auth_button.dart';
import 'package:chat_app/features/presentation/widgets/auth_input_fields.dart';
import 'package:chat_app/features/presentation/widgets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _onRegister(){
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
          username: _usernameController.text,
          email:_emailController.text,
          password: _passwordController.text),
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
                  AuthInputFields(hint: 'username', icon: Icons.person, controller: _usernameController),
                  SizedBox(height: 20),
                  AuthInputFields(hint: 'Email', icon: Icons.email, controller: _emailController),
                  SizedBox(height: 20),
                  AuthInputFields(hint: 'Password', icon: Icons.lock, controller: _passwordController,isPassword: true,),
                  SizedBox(height: 20),
                  BlocConsumer<AuthBloc,AuthState>(
                      builder: (context,state){
                        if (state is AuthLoading){
                    return Center(child: CircularProgressIndicator(),);}
                        return AuthButton(text: 'Register', onPressed: _onRegister);
                  },

                      listener: (context, state){
                    if(state is AuthSuccess){
                      Navigator.pushNamed(context, '/login');
                    }else if (state is AuthFailure){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                      }

                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20,),
                  LoginPrompt(title: 'Already have an account', subtitle: 'Click here to login', onTap: (){Navigator.pushNamed(context, '/login');} )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

