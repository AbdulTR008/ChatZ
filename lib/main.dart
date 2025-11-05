import 'package:chatz/screens/auth_screen.dart';
import 'package:chatz/screens/chat_screen.dart';
import 'package:chatz/screens/magic_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
// import 'package:magic_sdk/magic_sdk.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/onboarding_screen.dart';
import 'riverpod/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
  // Magic.instance = Magic('pk_live_12C1075A756C9A84');
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(

      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en'), // English
      //   Locale('ta'), // Spanish
      //   Locale('hi'), // Spanish
      //   Locale('ar'), // Spanish
      // ],
      locale: Locale(ref.watch(selectedLanguageProvider), ''),
      debugShowCheckedModeBanner: false,
      title: 'ChatZ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54), // WhatsApp dark teal
          primary: const Color(0xFF075E54),
          secondary: const Color(0xFF25D366), // WhatsApp green
        ),
        scaffoldBackgroundColor: const Color(0xFFECE5DD), // WhatsApp chat background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF25D366),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
