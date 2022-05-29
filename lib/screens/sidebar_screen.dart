import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tableforyou/models/user_model.dart';
import 'package:tableforyou/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  GoogleSignInAccount? _currentUser;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
  ]);
  @override
  void initState() {
    _googleSignIn.isSignedIn().then((isSignedIn) async {
      if (isSignedIn) {
        await _googleSignIn.signInSilently().then((value) => {_currentUser = value});

      } else {
        getUser();
      } 
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    final GoogleSignInAccount? gUser = _currentUser;
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.01, 0.2, 1],
            colors: [
              Color.fromRGBO(255, 45, 45, 1),
              Color.fromRGBO(255, 105, 105, 1),
              Colors.white
            ],
          ),
        ),
        child: ListView(
         
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: (loggedInUser.firstName == null)
                  ? (Text(
                      gUser?.displayName ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  )
                  : Text(
                      '${loggedInUser.firstName}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
              accountEmail: loggedInUser.email == null
                  ? (Text(gUser?.email ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)))
                  : Text(
                      '${loggedInUser.email}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
              currentAccountPicture: const CircleAvatar(
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            if (!user.emailVerified)
              (ListTile(
                title: const Text('Verify Email'),
                leading: const Icon(Icons.mail),
                onTap: () {
                  context
                      .read<FirebaseAuthMethods>()
                      .sendEmailVerification(context);
                },
              )),
            ListTile(
              title: const Text('Sign Out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                context.read<FirebaseAuthMethods>().signOut(context);
              },
            ),
            ListTile(
              title: const Text('Delete Account'),
              leading: const Icon(Icons.delete),
              onTap: () {
                context.read<FirebaseAuthMethods>().deleteAccount(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void getUser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
}
