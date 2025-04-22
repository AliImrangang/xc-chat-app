import 'dart:convert';
import 'package:chat_app/features/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usercases/login_use_case.dart';
import '../../domain/usercases/register_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final _storage = FlutterSecureStorage();

  AuthBloc({required this.registerUseCase, required this.loginUseCase})
    : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('Registering user: ${event.username}, ${event.email}');
    try {
      final user = await registerUseCase(
        event.username,
        event.email,
        event.password,
      );
      print('User registered successfully: $user');
      emit(AuthSuccess(message: "Registration successful"));
    } on http.Response catch (response) {
      print('HTTP Response Error: ${response.statusCode}');
      try {
        final message =
            json.decode(response.body)['message'] ?? 'Registration failed';
        print('Error message from backend: $message');
        emit(AuthFailure(error: message));
      } catch (_) {
        print('Failed to decode error message');
        emit(AuthFailure(error: 'Registration failed'));
      }
    } catch (e) {
      print('Exception occurred: $e');
      final errorMessage = e.toString();
      emit(AuthFailure(error: errorMessage));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('Logging in user: ${event.email}');

    try {
      final user = await loginUseCase(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      print('token: ${user.token}');
      emit(AuthSuccess(message: "Login successful"));

    } on LoginException catch (e) {
      print('LoginException: ${e.message}');
      emit(AuthFailure(error: e.message));

    } catch (e) {
      print('Exception occurred: $e');
      final errorMessage = e.toString().contains('Invalid credentials')
          ? 'Incorrect email or password'
          : 'Login failed. Please try again.';
      emit(AuthFailure(error: errorMessage));
    }
  }
}
class LoginException implements Exception {
  final String message;
  LoginException(this.message);
}

//   Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final user = await registerUseCase(
//         event.username, event.email, event.password,);
//       emit(AuthSuccess(message: "Registration successful"));
//     } catch (e) {
//       emit(AuthFailure(error: 'Registration failed'));
//     }
//   }
//
//   Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final user = await loginUseCase(
//         event.email,
//         event.password,
//       );
//       await _storage.write(key: 'token', value: user.token);
//       print('token: ${user.token}');
//       emit(AuthSuccess(message: "Login successful"));
//     } on http.Response catch (response) {
//       try {
//         final message = json.decode(response.body)['message'] ?? 'Login failed';
//         emit(AuthFailure(error: message));
//       } catch (_) {
//         emit(AuthFailure(error: 'Login failed'));
//       }
//     } catch (e) {
//       final errorMessage = e.toString().contains('Invalid credentials')
//           ? 'Incorrect email or password'
//           : 'Login failed. Please try again.';
//       emit(AuthFailure(error: errorMessage));
//     }
//   }
// }
