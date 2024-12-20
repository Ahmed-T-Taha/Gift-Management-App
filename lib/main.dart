import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gift_management_app/Views/event_details.dart';
import 'package:gift_management_app/Views/friend_event_list.dart';
import 'package:gift_management_app/Views/friend_gift_list.dart';
import 'Views/home.dart';
import 'Views/event_list.dart';
import 'Views/gift_list.dart';
import 'Views/gift_details.dart';
import 'Views/pledged_gifts.dart';
import 'Views/sign_in.dart';
import 'Views/sign_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/home',
      routes: {
        '/': (context) => const SignUpPage(),
        '/login': (context) => const SignInPage(),
        '/home': (context) => const HomePage(),
        '/events': (context) => const EventListPage(),
        '/friend-events': (context) => const FriendEventListPage(),
        '/gifts': (context) => const GiftListPage(),
        '/friend-gifts': (context) => const FriendGiftListPage(),
        '/gift-details': (context) => const GiftDetailsPage(),
        '/event-details': (context) => const EventDetailsPage(),
        '/pledged-gifts': (context) => const MyPledgedGiftsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
