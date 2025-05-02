import 'package:chat_app/features/chat/domain/usecases/fetch_daily_question_usecase.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:chat_app/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/core/socket_services.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/message_repository_impl.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chat_app/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:chat_app/features/contacts/domain/usecases/add_contact_usecase.dart';
import 'package:chat_app/features/contacts/domain/usecases/fetch_contacts_usecase.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:chat_app/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:chat_app/features/conversation/data/repositories/conversations_repository_impl.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_conversations_use_case.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:chat_app/features/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/presentation/pages/login_page.dart';
import 'package:chat_app/features/presentation/pages/registration_page.dart';
import 'package:chat_app/features/conversation/presentation/pages/conversations_page.dart';

import 'features/contacts/domain/usecases/fetch_recent_contacts_usecase.dart';
import 'features/domain/usercases/login_use_case.dart';
import 'features/domain/usercases/register_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final socketServices = SocketService();
  await socketServices.initSocket();

  final authRepository = AuthRepositoryImpl(authRepositoryDataSource: AuthRemoteDataSource());
  final conversationsRepository = ConversationsRepositoryImpl(
      conversationRemoteDataSource: ConversationRemoteDataSource());
  final messagesRepository = MessagesRepositoryImpl(remoteDataSource: MessagesRemoteDataSource());
  final contactsRepository = ContactsRepositoryImpl(remoteDataSource: ContactsRemoteDataSource());

  runApp(MyApp(
    authRepository: authRepository,
    conversationsRepository: conversationsRepository,
    messagesRepository: messagesRepository,
    contactsRepository: contactsRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationsRepositoryImpl conversationsRepository;
  final MessagesRepositoryImpl messagesRepository;
  final ContactsRepositoryImpl contactsRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationsRepository,
    required this.messagesRepository,
    required this.contactsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCase(repository: authRepository),
            loginUseCase: LoginUseCase(repository: authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => ConversationsBloc(
            fetchConversationsUseCase: FetchConversationsUseCase(conversationsRepository),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessagesUseCase: FetchMessagesUseCase(messagesRepository: messagesRepository),
            fetchDailyQuestionUseCase: FetchDailyQuestionUseCase(messagesRepository: messagesRepository)
          ),
        ),
        BlocProvider(
          create: (_) => ContactsBloc(
            fetchContactsUseCase: FetchContactUseCase(contactsRepository: contactsRepository),
            addContactUseCase: AddContactUseCase(contactsRepository: contactsRepository),
            checkOrCreateConversationUseCase: CheckOrCreateConversationUseCase(conversationRepository: conversationsRepository),
            fetchRecentContactsUseCase: FetchRecentContactsUseCase(contactsRepository: contactsRepository)
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const LoginPage( ),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegistrationPage(),
          '/conversationPage': (_) => const ConversationsPage(),
        },
      ),
    );
  }
}
