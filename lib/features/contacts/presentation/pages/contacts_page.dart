import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) {
          final contactsBloc = BlocProvider.of<ContactsBloc>(context);

          // Listen for successful contact addition
          if (state is ContactAdded) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contact added successfully! ✅')),
            );
            // Fetch contacts again to update the list
            contactsBloc.add(FetchContacts());
          }

          // Handle conversation ready state
          if (state is ConversationReady) {
            var res = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  conversationId: state.conversationId,
                  mate: state.contactName,
                ),
              ),
            );
            if (res == null) {
              contactsBloc.add(FetchContacts());
            }
          }
        },
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return ListTile(
                    title: Text(contact.username),
                    subtitle: Text(contact.email),
                    onTap: () {
                      BlocProvider.of<ContactsBloc>(context).add(
                        CheckOrCreateConversation(contact.id, contact.username),
                      );
                    },
                  );
                },
              );
            } else if (state is ContactsError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No contacts found'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add contact'),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(hintText: 'Enter contact email'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                BlocProvider.of<ContactsBloc>(context).add(AddContact(email));
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
