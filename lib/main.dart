import 'package:chat_app/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/message_repository_impl.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:chat_app/features/conversation/data/repositories/conversations_repository_impl.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_conversations_use_case.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:chat_app/features/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/presentation/pages/login_page.dart';
import 'package:chat_app/features/conversation/presentation/pages/conversations_page.dart';
import 'package:chat_app/features/presentation/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/domain/usercases/login_use_case.dart';
import 'features/domain/usercases/register_use_case.dart';

void main() {
  final authRepository = AuthRepositoryImpl(authRepositoryDataSource: AuthRemoteDataSource());
  final conversationsRepository = ConversationsRepositoryImpl(conversationRemoteDataSource: ConvesationsRemoteDataSource());
  final messagesRepository = MessagesRepositoryImpl(remoteDataSource: MessagesRemoteDataSource());
  runApp(MyApp(authRepository: authRepository,
    conversationsRepository: conversationsRepository,
    messagesRepository: messagesRepository,
  ));

}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationsRepositoryImpl conversationsRepository;
  final MessagesRepositoryImpl messagesRepository;


  const MyApp({super.key, required this.authRepository,
    required this.conversationsRepository,
    required this.messagesRepository,

  });


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(registerUseCase: RegisterUseCase(repository:authRepository),
            loginUseCase: LoginUseCase(repository:authRepository))
        ),
        BlocProvider(
            create: (_) => ConversationsBloc(
              fetchConversationsUseCase: FetchConversationsUseCase(conversationsRepository)

            )
        ),
        BlocProvider(
            create: (_) => ChatBloc(
             fetchMessagesUseCase: FetchMessagesUseCase(messagesRepository: messagesRepository)
            )
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/login': (_) => LoginPage(),              // fixed space typo
          '/register': (_) => RegistrationPage(),
          '/conversationPage': (_) => ConversationsPage(),            // fixed route name to match casing
        },

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
