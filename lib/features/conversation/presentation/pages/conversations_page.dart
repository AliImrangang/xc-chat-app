import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contacts/presentation/bloc/contacts_state.dart';
import '../../../contacts/presentation/pages/contacts_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    super.initState();
    print("Fetching conversations...");
    BlocProvider.of<ConversationsBloc>(context).add(FetchConversations());
    BlocProvider.of<ContactsBloc>(context).add(LoadRecentContacts(userId: 'validUserId')); // ✅ Ensure contacts load initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Recent Contacts', style: Theme.of(context).textTheme.titleMedium),
          ),
          BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
              if (state is ContactsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RecentContactsLoaded) {
                return state.recentContacts.isEmpty
                    ? _buildMessage('No recent contacts')
                    : _buildRecentContactsList(state.recentContacts);
              } else if (state is ContactsError) {
                return _buildMessage("Error: ${state.message}");
              }
              return _buildMessage('No conversations found');
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              ),
              child: BlocBuilder<ConversationsBloc, ConversationsState>(
                builder: (context, state) {
                  if (state is ConversationsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ConversationsLoaded) {
                    return _buildConversationsList(state.conversations);
                  } else if (state is ConversationsError) {
                    return _buildMessage("Error: ${state.message}");
                  }
                  return _buildMessage('No conversations found');
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
          // ✅ Refresh contacts automatically when returning from ContactsPage
          BlocProvider.of<ContactsBloc>(context).add(LoadRecentContacts(userId: 'validUserId'));
        },
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text("Add Contact", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(child: Text(message, style: Theme.of(context).textTheme.bodyMedium));
  }

  Widget _buildRecentContactsList(List<dynamic> contacts) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return _buildRecentContact(contact.participantName, contact.participantImage, context);
        },
      ),
    );
  }

  Widget _buildConversationsList(List<dynamic> conversations) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  conversationId: conversation.id,
                  mate: conversation.participantName,
                  profileImage: conversation.participantImage ?? "",
                ),
              ),
            );
          },
          child: _buildMessageTitle(
            conversation.participantName,
            conversation.participantImage ?? "",
            conversation.lastMessage ?? 'No messages yet',
            conversation.lastMessageTime?.toString() ?? 'No time available',
          ),
        );
      },
    );
  }

  Widget _buildMessageTitle(String name, String? profileImage, String message, String time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: profileImage != null && profileImage.isNotEmpty
            ? NetworkImage(profileImage)
            : AssetImage("assets/default_avatar.png") as ImageProvider,
      ),
      title: Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(message, style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis),
      trailing: Text(time, style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildRecentContact(String username, String? profileImage, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: profileImage != null && profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : AssetImage("assets/default_avatar.png") as ImageProvider,
          ),
          const SizedBox(height: 5),
          Text(username, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}