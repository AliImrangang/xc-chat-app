
import '../entities/contacts_entity.dart';

abstract class ContactsRepository{
  Future<List<ContactEntity>> fetchContacts();
  Future<void> addContact ({required String email});

}