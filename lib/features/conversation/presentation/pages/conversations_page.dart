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
    BlocProvider.of<ConversationsBloc>(context).add(FetchConversations());
    BlocProvider.of<ContactsBloc>(context).add(LoadRecentContacts(userId: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "messages",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent Contacts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
              if (state is RecentContactsLoaded) {
                if (state.recentContacts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No recent contacts', style: Theme.of(context).textTheme.bodyMedium),
                  );
                }
                return Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recentContacts.length,
                    itemBuilder: (context, index) {
                      final contact = state.recentContacts[index];
                      return _buildRecentContact(contact.participantName, contact.participantImage, context);
                    },
                  ),
                );
              } else if (state is ContactsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ContactsError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('No conversations found'));
            },
          ),

          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: BlocBuilder<ConversationsBloc, ConversationsState>(
                builder: (context, state) {
                  if (state is ConversationsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ConversationsLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  conversationId: conversation.id,
                                  mate: conversation.participantName,
                                  profileImage: conversation.participantImage,
                                ),
                              ),
                            );
                          },
                          child: _buildMessageTitle(
                            conversation.participantName,
                            conversation.participantImage,
                            conversation.lastMessage ?? 'No messages yet',
                            conversation.lastMessageTime.toString() ??
                                'No time available',
                          ),
                        );
                      },
                    );
                  } else if (state is ConversationsError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text('No conversations found'));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
        },
        backgroundColor: DefaultColors.buttonColor,
        child: Icon(Icons.contacts),
      ),
    );
  }

  Widget _buildMessageTitle(String name,String profileImage, String message, String time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildRecentContact(String username, String profileImage, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profileImage),
          ),
          const SizedBox(height: 5),
          Text(
            username,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}







// import 'package:chat_app/core/theme.dart';
// import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
// import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
// import 'package:chat_app/features/conversation/presentation/bloc/conversations_bloc.dart';
// import 'package:chat_app/features/conversation/presentation/bloc/conversations_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../contacts/presentation/pages/contacts_page.dart';
//
// class ConversationsPage extends StatefulWidget {
//   const ConversationsPage({Key? key}): super(key: key);
//
//
//   @override
//   State<ConversationsPage> createState()=> _ConversationsPageState();
// }
//
// class _ConversationsPageState extends State<ConversationsPage>{
//   @override
// void initState(){
//     super.initState();
//     BlocProvider.of<ConversationsBloc>(context).add(FetchConversations());
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title:  Text("messages",
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//         centerTitle:false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarHeight: 70,
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search),
//             onPressed: () {  },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 100,
//             padding: EdgeInsets.all(5),
//             child:ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _buildRecentContact('berry',context),
//               ],
//             ) ,
//           ),
//
//           SizedBox(height: 10,),
//           Expanded(child: Container(
//             decoration: BoxDecoration(
//               color: DefaultColors.messageListPage,
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(50),
//                 topLeft: Radius.circular(50),
//               )
//             ),
//             child: BlocBuilder<ConversationsBloc,ConversationsState>(
//               builder: (context,state) {
//                 if (state is ConversationsLoading){
//                   return Center(child: CircularProgressIndicator(),);
//                 }
//                 else if (state is ConversationsLoaded){
//                   return ListView.builder(
//                       itemCount: state.conversations.length,
//                       itemBuilder: (context,index){
//                         final conversation = state.conversations[index];
//                         return GestureDetector(
//                           onTap: (){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>
//                             ChatPage(conversationId: conversation.id, mate: conversation.participantName)));
//                           },
//                           child: _buildMessageTitle(
//                             conversation.participantName,
//                             conversation.lastMessage,
//                             conversation.lastMessageTime.toString()),
//                         );
//                   },
//                 );
//                 }
//                 else if (state is ConversationsError){
//                   return Center(child: Text(state.message),);
//                 }
//                 return Center(child: Text('No conversations found'),);
//               }
//             ),
//           )
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: (){
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context)=>ContactsPage())
//             );
//           },
//         backgroundColor: DefaultColors.buttonColor,
//         child: Icon(Icons.contacts),
//
//
//       ),
//     );
//   }
//
// Widget _buildMessageTitle(String name,String message, String time){
// return ListTile(
//   contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//   leading: CircleAvatar(
//     radius: 30,
//     backgroundImage: NetworkImage('http://via.placeholder.com/150'),
//   ),
//   title: Text(
//     name,
//     style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//   ),
// subtitle: Text(message,
// style: TextStyle(color: Colors.grey),
// overflow: TextOverflow.ellipsis,
// ),
//   trailing: Text(time,
//   style: TextStyle(color: Colors.red),
//   ),
// );
// }
//
// Widget _buildRecentContact(String name,BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 10),
//     child: Column(
//       children: [
//         const CircleAvatar(
//           radius: 30,
//           backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Use backgroundImage for NetworkImage
//         ),
//         const SizedBox(height: 5), // Added const here as SizedBox doesn't depend on any variables
//         Text(
//           "test",
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//       ],
//     ),
//   );
// }}