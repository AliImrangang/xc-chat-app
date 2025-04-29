import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';


class FetchContactUseCase{
  final ContactsRepository contactsRepository;

  FetchContactUseCase({required this.contactsRepository});

  Future<List<ContactEntity>> call()async{
    return await contactsRepository.fetchContacts();
  }
}