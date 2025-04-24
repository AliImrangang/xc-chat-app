import 'package:chat_app/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';

abstract class ContactRepository {
  Future<void> addContact({required String email});
  Future<List<ContactEntity>> fetchContacts();
}
class ContactsRepositoryImpl implements ContactRepository {
  final ContactsRemoteDataSource remoteDataSource;

  ContactsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addContact({required String email}) async {
    return await remoteDataSource.addContact(email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    return await remoteDataSource.fetchContacts();
  }
}
