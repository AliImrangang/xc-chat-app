import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';

class AddContactUseCase{
  final ContactRepository contactRepository;

  AddContactUseCase({required this.contactRepository});

  Future<void> call({required String email}) async{
    return await contactRepository.addContact(email: email);
  }
}