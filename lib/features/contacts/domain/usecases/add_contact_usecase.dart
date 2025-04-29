import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';

class AddContactUseCase{
  final ContactsRepository contactsRepository;

  AddContactUseCase({required this.contactsRepository});

  Future<void> call({required String email}) async{
    return await contactsRepository.addContact(email: email);
  }
}