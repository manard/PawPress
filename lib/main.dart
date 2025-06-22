import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawpress/models/petOwner.dart';
import 'package:pawpress/screens/OrderSuccessScreen.dart';
import 'package:pawpress/screens/home_page.dart';
import 'package:pawpress/screens/OwnerProfile.dart';
import 'package:pawpress/screens/Welcome.dart';
import 'package:pawpress/screens/AdoptionScreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
    "🔕 [Background] ${message.notification?.title}: ${message.notification?.body}",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print("⚠️⚠️⚠️ initState of MyApp is running");
    initFCM();
  }

  void initFCM() async {
    print("🔥🔥🔥🔥 initFCM is running...");
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // طلب الإذن
    await messaging.requestPermission();

    // عرض FCM token
    String? token = await messaging.getToken();
    print("📲 FCM Token: $token");

    // استقبال إشعارات أثناء foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        "🔔 [Foreground] ${message.notification?.title}: ${message.notification?.body}",
      );

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'PawPress Notifications',
              channelDescription:
                  'This channel is used for important PawPress notifications.',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // عند فتح التطبيق من خلال الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        "📬 [Opened] ${message.notification?.title}: ${message.notification?.body}",
      );
      // ممكن ننتقل لصفحة معينة هون حسب البيانات القادمة
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
      routes: {
        '/adoption': (context) {
          final petID = ModalRoute.of(context)!.settings.arguments as int;
          return AdoptionScreen(petID: petID);
        },
        '/order-success': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args == null || args is! petOwner) {
            return const Scaffold(
              body: Center(child: Text('No owner data provided')),
            );
          }
          return OrderSuccessScreen(owner: args);
        },
      },
    );
  }
}
