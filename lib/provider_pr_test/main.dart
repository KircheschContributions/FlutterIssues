import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_issues/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> providerPrTestMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'userChanges() streaming old data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('userChanges() streaming old data'),
        ),
        // body: const _StreamProviderTest(),
        body: const _ListenableProviderTest(),
      ),
    );
  }
}

class _StreamProviderTest extends StatelessWidget {
  const _StreamProviderTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (context) => FirebaseAuth.instance.userChanges(),
      builder: (context, _) {
        final userTest = context.watch<User?>();

        void onPressed() {
          if (userTest != null) {
            FirebaseAuth.instance.signOut();
          } else {
            FirebaseAuth.instance.signInAnonymously();
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("press"),
            ),
            Text(userTest != null ? "Logged in" : "Logged out"),
          ],
        );
      },
    );
  }
}

class _ListenableProviderTestClass extends ChangeNotifier {
  _ListenableProviderTestClass() {
    FirebaseAuth.instance.userChanges().listen((event) {
      user = event;
      notifyListeners();
    });
  }

  User? user;
}

class _ListenableProviderTest extends StatelessWidget {
  const _ListenableProviderTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => _ListenableProviderTestClass(),
      builder: (context, _) {
        final userTestBlah = context.watch<_ListenableProviderTestClass?>();
        final userTest = userTestBlah?.user;

        void onPressed() {
          if (userTest != null) {
            FirebaseAuth.instance.signOut();
          } else {
            FirebaseAuth.instance.signInAnonymously();
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("press"),
            ),
            Text(userTest != null ? "Logged in" : "Logged out"),
          ],
        );
      },
    );
  }
}

// I am not sure how the other providers work or if there are other providers
