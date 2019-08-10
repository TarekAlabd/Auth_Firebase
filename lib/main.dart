import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Auth Firebase"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    onPressed: () => _gSignIn(),
                    child: Text("Google-signin"),
                    color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    onPressed: () => _signInWithEmail(),
                    child: Text("Signin with Email"),
                    color: Colors.orange,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    onPressed: () => _createUser(),
                    child: Text("Create Account"),
                    color: Colors.purple,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () => _logOutGoogle(),
                  child: Text("Logout from G-Account"),
                  color: Colors.redAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () => _logOutEmail(),
                  child: Text("Logout from Email"),
                  color: Colors.redAccent,
                ),
              ),
              Image.network(_imageUrl == null || _imageUrl.isEmpty ? "https://bre.is/V4BR5qJt"
                : _imageUrl),
            ],
          ),
        ));
  }

  Future<FirebaseUser> _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("User us: ${user.photoUrl}");
    setState(() {
      _imageUrl = user.photoUrl;
    });
    return user;
  }

  Future _createUser() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: "dontdothat@gmail.com", password: "beeebebbbe")
    .then((userNew) {
      print("User Name Created: ${userNew.user.displayName}");
      print("Email: ${userNew.user.email}");
    });
  }

  _logOutGoogle() {
    setState(() {
      _googleSignIn.signOut();
      _imageUrl = null;
    });
  }

  _signInWithEmail() {
    _auth.signInWithEmailAndPassword(
        email: "dontdothat@gmail.com", password: "beeebebbbe")
        .catchError((error) {
          print("There's an error: ${error.toString()}");
    }).then((newUser) {
      print("Email: ${newUser.user.email}");
    });
  }

  _logOutEmail() {
    setState(() {
      _auth.signOut();
    });
  }
}

