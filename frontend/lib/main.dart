import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stals_frontend/screens/owner/edit_accomm.dart';
import 'package:stals_frontend/screens/accomm.dart';
import 'package:stals_frontend/screens/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stals_frontend/utils/export_screens.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TokenProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/signup_info': (context) => SignUpForm(),
        '/verify_user': (context) => VerificationPage(),
        '/homepage': (context) => const UnregisteredHomepage(),
        '/signed_homepage': (context) => const RegisteredHomepage(),
        '/accomm': (context) => AccommPage(),
        '/add_accommodation': (context) => const AddAccommPage(),
        '/admin': (context) => const AdminDashBoard(),
        '/view_owned_accomms': (context) => const ViewOwnedAccomms(),
        '/owned/accomm/edit': (context) => const EditAccomm(),
        '/admin/view_users': (context) => const ViewUsersPage(),
        '/admin/view_accomms': (context) => const AdminViewAccommodations(),
        '/admin/verify_accomm': (context) => AccommPageProof(),
        '/admin/view_reports': (context) => const ViewReportsPage(),
        // '/userprofile': (context) => const UserProfile(),
      },
      theme: ThemeData(
        fontFamily: 'SFProDisplayRegular',
        //primarySwatch: MaterialColor(Color(0xff19535F), swatch),
        //accentColor: Color(0xff0B7A75),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<void> _initializeUserProvider() async {
    await context.read<UserProvider>().loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeUserProvider(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (context.watch<UserProvider>().isAuthenticated) {
          if (context.watch<UserProvider>().isAdmin)
            return const AdminDashBoard();
          if (context.watch<UserProvider>().isOwner)
            return const ViewOwnedAccomms();
          return const RegisteredHomepage();
        } else {
          return const UnregisteredHomepage();
        }
      },
    );
  }
}
