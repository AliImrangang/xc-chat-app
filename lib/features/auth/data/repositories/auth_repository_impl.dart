import 'package:chat_app/features/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/domain/entities/user_entity.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource authRepositoryDataSource;

  AuthRepositoryImpl({required this.authRepositoryDataSource});

  @override
  Future<UserEntity> login(String email, String password)async {
  return authRepositoryDataSource.login(email:email,password:password);

  }

  @override
  Future<UserEntity> register(String username, String email, String password) async{
  return await authRepositoryDataSource.register(username:username ,email:email,password:password);

  }
  

}