import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/theme.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
final ValueNotifier<ThemeMode> themeNotifier =
ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(    options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase error: $e");
  }

  runApp(const FreelancerApp());
}

class FreelancerApp extends StatelessWidget {
  const FreelancerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Freelancer App',
          theme: appTheme,
          darkTheme: appDarkTheme,
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}