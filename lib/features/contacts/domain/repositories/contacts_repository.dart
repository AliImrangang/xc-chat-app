
import '../entities/contacts_entity.dart';

abstract class ContactRepository{
  Future<Future<ContactEntity>> fetchContacts();
  Future<void> addContact ({required String email});

}