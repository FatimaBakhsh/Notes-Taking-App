import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/home_screen.dart';
import 'view/auth/login_screen.dart';
import 'viewmodel/auth_provider.dart';
import 'viewmodel/note_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Initial route
        routes: {
          '/': (context) =>
              AuthWrapper(), // Decides whether to show Login or Home
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

// Wrapper to show HomeScreen or LoginScreen based on authentication state
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        print("Auth State Changed: ${auth.user}");
        return auth.user != null ? HomeScreen() : LoginScreen();
      },
    );
  }
}
