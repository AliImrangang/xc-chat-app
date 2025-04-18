
import '../repositories/auth_repository.dart' show AuthRepository;
import '../entities/user_entity.dart';

class RegisterUseCase{
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserEntity>call(String username,String email, String password){
    return repository.register( username,email, password);
  }
}