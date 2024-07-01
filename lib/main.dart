import 'package:chat_app/Screens/authentication_screen.dart';
import 'package:chat_app/blocs/chat_bloc.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCtXUEcLvwyQcmkFX3kl_F-CpO-z_d_XFg",
        authDomain: "flutterchatapp-64ac6.firebaseapp.com",
        projectId: "flutterchatapp-64ac6",
        storageBucket: "flutterchatapp-64ac6.appspot.com",
        messagingSenderId: "32817270065",
        appId: "1:32817270065:web:61a64ef28f4063d8c4f410"),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc(ChatRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: _getLandingPage(),
      ),
    );
  }

  Widget _getLandingPage() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      return HomeScreen();
    } else {
      return const AuthenticationScreen();
    }
  }
}
