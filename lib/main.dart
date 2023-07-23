// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logingoogle/pages/home_page.dart';
import 'package:logingoogle/resources/auth_methods.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 272768271706-ke2cv04qbvjag2h6casi06dre9fsph17.apps.googleusercontent.com
class _MyHomePageState extends State<MyHomePage> {
//  final AuthMethods _authMethods = AuthMethods();

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          print(e);
          res = false;
        } catch (e) {
          print(e);
        }
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {}
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Center(
        child: ElevatedButton(
            child: Text(
              'Login with Google',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () async {
              bool res = await signInWithGoogle(context);
              if (res) {
                Navigator.pushNamed(context, '/home');
              }
            }
            // onPressed: () async {
            //   bool res = await _authMethods.signInWithGoogle(context);
            //   if (res) {
            //     Navigator.pushNamed(context, '/home');
            //   }
            // },
            ),
      ),
    );
  }
}
