import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stals_frontend/screens/admin/admin_dashboard.dart';
import 'package:stals_frontend/screens/admin/admin_view_accommodations.dart';
import 'package:stals_frontend/screens/admin/admin_view_pending_approved.dart';
import 'package:stals_frontend/screens/admin/admin_view_users.dart';
import 'package:stals_frontend/screens/admin/admin_verify_accomm.dart';
import 'package:stals_frontend/screens/admin/admin_view_reports.dart';
import 'package:stals_frontend/screens/owner/add_accomm.dart';
import 'package:stals_frontend/screens/owner/edit_accomm.dart';
import 'package:stals_frontend/screens/owner/owned_accomm.dart';
import 'package:stals_frontend/screens/signin.dart';
import 'package:stals_frontend/screens/signup.dart';
import 'package:stals_frontend/screens/homepage.dart';
import 'package:stals_frontend/screens/registered_user/homepage_signed.dart';
import 'package:stals_frontend/screens/accomm.dart';
import 'package:stals_frontend/screens/owner/view_manage_accomms.dart';
import 'package:stals_frontend/screens/signup_form.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:stals_frontend/screens/verify_user.dart';

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
      title: 'CMSC 128 STALS',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        // '/': (context) => MyHomePage("CMSC 128 STALS"),
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
        '/owned/accomm': (context) => OwnedAccommPage(),
        '/owned/accomm/edit': (context) => const EditAccomm(),
        '/admin/view_users': (context) => const ViewUsersPage(),
        '/admin/view_accomms': (context) => const AdminViewAccommodations(),
        '/admin/verify_accomm': (context) => AccommPageProof(),
        '/admin/view_reports': (context) => const ViewReportsPage(),
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

// Removed the temporary drawer for the frontend. I haven't tried the logging in and logging out functionality. If you need to revert for development,
// uncomment the code below

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//           child: ListView(padding: EdgeInsets.zero, children: [
//         ListTile(
//           title: const Text('Sign In Page'),
//           trailing: const Icon(Icons.person),
//           onTap: () {
//             Navigator.pushNamed(context, '/signin');
//           },
//         ),
//         ListTile(
//           title: const Text('Sign Up Page'),
//           trailing: const Icon(Icons.person_search_sharp),
//           onTap: () {
//             Navigator.pushNamed(context, '/signup');
//           },
//         ),
//         ListTile(
//           title: const Text('Unregistered Homepage'),
//           trailing: const Icon(Icons.note_sharp),
//           onTap: () {
//             Navigator.pushNamed(context, '/homepage');
//           },
//         ),
//         ListTile(
//           title: const Text('Registered Homepage'),
//           trailing: const Icon(Icons.home),
//           onTap: () {
//             Navigator.pushNamed(context, '/signed_homepage');
//           },
//         ),
//         ListTile(
//           title: const Text('Accommodation'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/accomm');
//           },
//         ),
//         ListTile(
//           title: const Text('Admin Dashboard'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/admin');
//           },
//         ),
//         ListTile(
//           title: const Text('View Owned Accommodations'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/view_owned_accomms');
//           },
//         ),
//         ListTile(
//           title: const Text('Edit Accommodation'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/owned/accomm/edit');
//           },
//         ),
//         ListTile(
//           title: const Text('Owner Add Accommodations Page'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/add_accommodation');
//           },
//         ),
//         ListTile(
//           title: const Text('Admin View Users Page'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/admin/view_users');
//           },
//         ),
//         ListTile(
//           title: const Text('Admin View Accommodations Page'),
//           trailing: const Icon(Icons.construction),
//           onTap: () {
//             Navigator.pushNamed(context, '/admin/view_accomms');
//           },
//         ),
// ListTile(
//   title: const Text('Logout'),
//   trailing: const Icon(Icons.logout),
//   onTap: () {
//     Provider.of<TokenProvider>(context, listen: false)
//         .removeToken("DO NOT REMOVE THIS PARAM");
//     Provider.of<UserProvider>(context, listen: false)
//         .removeUser("DO NOT REMOVE THIS PARAM");

//     print("Logged out");
//   },
// ),
//       ])),
//       appBar: AppBar(
//         title: const Text("CMSC 128 STALS"),
//         backgroundColor: const Color.fromARGB(255, 67, 134, 221),
//       ),
//     );
//   }
// }

// Comment the code below if needed for development.
// What it's *supposed* to do is if you're logged in, it'll go to the registered homepage, else unregistered homepage.
// Not sure if my implementation is correct, pls fix hehe

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (context.watch<UserProvider>().isAuthenticated) {
      return const RegisteredHomepage();
    } else {
      return const UnregisteredHomepage();
    }
  }
}
