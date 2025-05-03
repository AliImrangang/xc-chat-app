import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';
import '../../domain/entities/contacts_entity.dart';

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
      appBar: AppBar(title: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold))),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) async {
          final contactsBloc = BlocProvider.of<ContactsBloc>(context);

          if (state is ContactAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ Contact added successfully!')),
            );
            contactsBloc.add(FetchContacts());
          }

          if (state is ContactsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ Error: ${state.message}')),
            );
          }

          if (state is ConversationReady) {
            var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  conversationId: state.conversationId,
                  mate: state.contact.username,
                  profileImage: state.profileImage ?? "",
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
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: contact.profileImage != null
                            ? NetworkImage(contact.profileImage!)
                            : AssetImage("assets/default_avatar.png") as ImageProvider,
                        radius: 25,
                      ),
                      title: Text(contact.username, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(contact.email, style: TextStyle(color: Colors.grey[600])),
                      onTap: () {
                        print("Starting conversation with: ${contact.username}");
                        BlocProvider.of<ContactsBloc>(context).add(
                          CheckOrCreateConversation(
                            contactId: contact.id,
                            contact: contact,
                            profileImage: contact.profileImage ?? "",
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is ContactsError) {
              return Center(
                child: Text("❌ Error: ${state.message}", style: TextStyle(color: Colors.red, fontSize: 16)),
              );
            }
            return Center(child: Text('No contacts found', style: TextStyle(color: Colors.grey, fontSize: 16)));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddContactDialog(context),
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text("Add Contact", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('➕ Add a Contact', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter contact email',
            prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final email = emailController.text.trim();

              if (email.isEmpty || !email.contains('@')) {
                print("Attempted to add an invalid email. Request blocked.");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Please enter a valid email address!')),
                );
                return;
              }

              print("Adding new contact: $email");
              BlocProvider.of<ContactsBloc>(context).add(AddContact(email: email));
              Navigator.pop(context);
            },
            icon: Icon(Icons.check, color: Colors.white),
            label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}