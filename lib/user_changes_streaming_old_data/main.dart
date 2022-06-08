import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_issues/firebase_options.dart';

Future<void> main() async {
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
        body: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            String results;

            if (snapshot.hasData) {
              User user = snapshot.data!;

              if (user.isAnonymous) {
                results = "Anonymous User";
              } else {
                results = "User ${user.email}";
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              results = "Loading...";
            } else {
              results = "Disconected";
            }

            Future<void> onPressed() async {
              if (snapshot.hasData) {
                User user = snapshot.data!;
                if (user.isAnonymous) {
                  // To do : Link user
                } else {
                  // To do : disconect user
                }
              } else {
                // to do : sign in anonymously
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text("press"),
                ),
                Text(results),
              ],
            );
          },
        ),
      ),
    );
  }
}
