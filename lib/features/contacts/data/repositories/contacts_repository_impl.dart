import 'package:chat_app/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
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

  @override
  Future<List<ContactEntity>> getRecentContacts({required String userId}) async {
    // Pass userId to the remoteDataSource to fetch recent contacts
    return await remoteDataSource.fetchRecentContacts(userId: userId);
  }
}
