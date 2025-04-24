import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:chat_app/features/contacts/domain/repositories/contacts_repository.dart';


class FetchContactUseCase{
  final ContactRepository contactRepository;

  FetchContactUseCase({required this.contactRepository});

  Future<Future<ContactEntity>> call()async{
    return await contactRepository.fetchContacts();
  }
}