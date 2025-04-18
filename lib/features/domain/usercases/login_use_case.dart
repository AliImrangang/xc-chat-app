
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase{
  final AuthRepository repository;

  LoginUseCase({required this.repository});

Future<UserEntity>call(String email, String password){
    return repository.login(email, password);
  }
}