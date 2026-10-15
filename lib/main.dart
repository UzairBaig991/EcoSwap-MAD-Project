import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/network/notification_service.dart';
import 'routing/app_router.dart';
import 'features/auth/providers/auth_provider.dart';

// Firebase Options from project google-services configuration
const FirebaseOptions _webFirebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyD6TsigHDexQW9PjvDHFpRKV4xc3lbVK-Q",
  appId: "1:892620643197:android:35de7701e6361e0892ca14",
  messagingSenderId: "892620643197",
  projectId: "ecoswap-cf004",
  authDomain: "ecoswap-cf004.firebaseapp.com",
  storageBucket: "ecoswap-cf004.firebasestorage.app",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Offline Data Storage
  try {
    await Hive.initFlutter();
  } catch (e) {
    debugPrint("Hive init info: $e");
  }

  // Initialize Firebase safely without duplicate app errors on hot restart
  try {
    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        await Firebase.initializeApp(options: _webFirebaseOptions);
      } else {
        await Firebase.initializeApp();
        await NotificationService.instance.initialize();
      }
    }
  } catch (e) {
    debugPrint("Firebase initialization info: $e");
  }

  runApp(
    const ProviderScope(
      child: EcoSwapApp(),
    ),
  );
}

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class EcoSwapApp extends ConsumerWidget {
  const EcoSwapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Save FCM Token when user logs in on mobile
    ref.listen(authStateProvider, (prev, next) {
      final user = next.asData?.value;
      if (user != null && !kIsWeb) {
        NotificationService.instance.saveFcmToken(user.uid);
      }
    });

    return MaterialApp.router(
      title: 'EcoSwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
